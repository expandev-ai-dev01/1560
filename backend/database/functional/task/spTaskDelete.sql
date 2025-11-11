/**
 * @summary
 * Soft deletes a task by setting the deleted flag to 1.
 * Also soft deletes all related subtasks, tags, and attachments.
 * 
 * @procedure spTaskDelete
 * @schema functional
 * @type stored-procedure
 * 
 * @endpoints
 * - DELETE /api/v1/internal/task/:id
 * 
 * @parameters
 * @param {INT} idAccount
 *   - Required: Yes
 *   - Description: Account identifier for multi-tenancy
 * 
 * @param {INT} idUser
 *   - Required: Yes
 *   - Description: User identifier (task owner)
 * 
 * @param {INT} idTask
 *   - Required: Yes
 *   - Description: Task identifier
 * 
 * @returns Success indicator
 * 
 * @testScenarios
 * - Valid task deletion
 * - Task not found
 * - Access denied for different user
 * - Verify related data is also deleted
 */
CREATE OR ALTER PROCEDURE [functional].[spTaskDelete]
  @idAccount INTEGER,
  @idUser INTEGER,
  @idTask INTEGER
AS
BEGIN
  SET NOCOUNT ON;

  /**
   * @validation Required parameter validation
   * @throw {idAccountRequired}
   */
  IF (@idAccount IS NULL)
  BEGIN
    ;THROW 51000, 'idAccountRequired', 1;
  END;

  /**
   * @validation Required parameter validation
   * @throw {idUserRequired}
   */
  IF (@idUser IS NULL)
  BEGIN
    ;THROW 51000, 'idUserRequired', 1;
  END;

  /**
   * @validation Required parameter validation
   * @throw {idTaskRequired}
   */
  IF (@idTask IS NULL)
  BEGIN
    ;THROW 51000, 'idTaskRequired', 1;
  END;

  /**
   * @validation Task existence and ownership validation
   * @throw {taskDoesntExist}
   */
  IF NOT EXISTS (
    SELECT * FROM [functional].[task] [tsk]
    WHERE [tsk].[idTask] = @idTask
      AND [tsk].[idAccount] = @idAccount
      AND [tsk].[idUser] = @idUser
      AND [tsk].[deleted] = 0
  )
  BEGIN
    ;THROW 51000, 'taskDoesntExist', 1;
  END;

  BEGIN TRY
    BEGIN TRAN;

      /**
       * @rule {fn-task-delete} Soft delete task
       */
      UPDATE [functional].[task]
      SET [deleted] = 1
      WHERE [idTask] = @idTask
        AND [idAccount] = @idAccount;

      /**
       * @rule {fn-subtask-cascade-delete} Soft delete related subtasks
       */
      UPDATE [functional].[subtask]
      SET [deleted] = 1
      WHERE [idTask] = @idTask
        AND [idAccount] = @idAccount;

      /**
       * @rule {fn-tag-cascade-delete} Hard delete related tags
       */
      DELETE FROM [functional].[taskTag]
      WHERE [idTask] = @idTask
        AND [idAccount] = @idAccount;

      /**
       * @rule {fn-attachment-cascade-delete} Soft delete related attachments
       */
      UPDATE [functional].[taskAttachment]
      SET [deleted] = 1
      WHERE [idTask] = @idTask
        AND [idAccount] = @idAccount;

      /**
       * @output {TaskDeleted, 1, 1}
       * @column {BIT} success
       * - Description: Deletion success indicator
       */
      SELECT 1 AS [success];

    COMMIT TRAN;
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
  END CATCH;
END;
GO