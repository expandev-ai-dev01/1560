/**
 * @summary
 * Updates an existing task with new information including title,
 * description, due date, priority, status, and category.
 * 
 * @procedure spTaskUpdate
 * @schema functional
 * @type stored-procedure
 * 
 * @endpoints
 * - PUT /api/v1/internal/task/:id
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
 * @param {NVARCHAR(100)} title
 *   - Required: Yes
 *   - Description: Task title (3-100 characters)
 * 
 * @param {NVARCHAR(1000)} description
 *   - Required: No
 *   - Description: Task description (max 1000 characters)
 * 
 * @param {DATE} dueDate
 *   - Required: No
 *   - Description: Task due date
 * 
 * @param {TIME} dueTime
 *   - Required: No
 *   - Description: Task due time
 * 
 * @param {INT} priority
 *   - Required: Yes
 *   - Description: Priority level (0=low, 1=medium, 2=high)
 * 
 * @param {INT} status
 *   - Required: Yes
 *   - Description: Task status (0=pending, 1=in progress, 2=completed, 3=cancelled)
 * 
 * @param {INT} idCategory
 *   - Required: No
 *   - Description: Category identifier
 * 
 * @param {INT} estimatedTime
 *   - Required: No
 *   - Description: Estimated time in minutes (5-1440)
 * 
 * @returns Success indicator
 * 
 * @testScenarios
 * - Valid update with all fields
 * - Valid update with partial fields
 * - Validation failure for empty title
 * - Validation failure for invalid priority
 * - Task not found
 * - Access denied for different user
 */
CREATE OR ALTER PROCEDURE [functional].[spTaskUpdate]
  @idAccount INTEGER,
  @idUser INTEGER,
  @idTask INTEGER,
  @title NVARCHAR(100),
  @description NVARCHAR(1000) = '',
  @dueDate DATE = NULL,
  @dueTime TIME = NULL,
  @priority INTEGER,
  @status INTEGER,
  @idCategory INTEGER = NULL,
  @estimatedTime INTEGER = NULL
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

  /**
   * @validation Required parameter validation
   * @throw {titleRequired}
   */
  IF (@title IS NULL OR LTRIM(RTRIM(@title)) = '')
  BEGIN
    ;THROW 51000, 'titleRequired', 1;
  END;

  /**
   * @validation Title length validation
   * @throw {titleTooShort}
   */
  IF (LEN(LTRIM(RTRIM(@title))) < 3)
  BEGIN
    ;THROW 51000, 'titleTooShort', 1;
  END;

  /**
   * @validation Title length validation
   * @throw {titleTooLong}
   */
  IF (LEN(@title) > 100)
  BEGIN
    ;THROW 51000, 'titleTooLong', 1;
  END;

  /**
   * @validation Priority validation
   * @throw {invalidPriority}
   */
  IF (@priority IS NULL OR @priority < 0 OR @priority > 2)
  BEGIN
    ;THROW 51000, 'invalidPriority', 1;
  END;

  /**
   * @validation Status validation
   * @throw {invalidStatus}
   */
  IF (@status IS NULL OR @status < 0 OR @status > 3)
  BEGIN
    ;THROW 51000, 'invalidStatus', 1;
  END;

  /**
   * @validation Estimated time validation
   * @throw {estimatedTimeTooShort}
   */
  IF (@estimatedTime IS NOT NULL AND @estimatedTime < 5)
  BEGIN
    ;THROW 51000, 'estimatedTimeTooShort', 1;
  END;

  /**
   * @validation Estimated time validation
   * @throw {estimatedTimeTooLong}
   */
  IF (@estimatedTime IS NOT NULL AND @estimatedTime > 1440)
  BEGIN
    ;THROW 51000, 'estimatedTimeTooLong', 1;
  END;

  /**
   * @validation Category existence validation
   * @throw {categoryDoesntExist}
   */
  IF (@idCategory IS NOT NULL AND NOT EXISTS (
    SELECT * FROM [functional].[category] [cat]
    WHERE [cat].[idCategory] = @idCategory
      AND [cat].[idAccount] = @idAccount
      AND [cat].[deleted] = 0
  ))
  BEGIN
    ;THROW 51000, 'categoryDoesntExist', 1;
  END;

  BEGIN TRY
    BEGIN TRAN;

      /**
       * @rule {fn-task-update} Update task with validated parameters
       */
      UPDATE [functional].[task]
      SET
        [title] = @title,
        [description] = @description,
        [dueDate] = @dueDate,
        [dueTime] = @dueTime,
        [priority] = @priority,
        [status] = @status,
        [idCategory] = @idCategory,
        [estimatedTime] = @estimatedTime,
        [dateModified] = GETUTCDATE()
      WHERE [idTask] = @idTask
        AND [idAccount] = @idAccount;

      /**
       * @output {TaskUpdated, 1, 1}
       * @column {BIT} success
       * - Description: Update success indicator
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