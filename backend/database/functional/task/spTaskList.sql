/**
 * @summary
 * Lists all tasks for a specific user with filtering options by status,
 * priority, and due date range.
 * 
 * @procedure spTaskList
 * @schema functional
 * @type stored-procedure
 * 
 * @endpoints
 * - GET /api/v1/internal/task
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
 * @param {INT} status
 *   - Required: No
 *   - Description: Filter by status (0=pending, 1=in progress, 2=completed, 3=cancelled)
 * 
 * @param {INT} priority
 *   - Required: No
 *   - Description: Filter by priority (0=low, 1=medium, 2=high)
 * 
 * @param {DATE} dueDateFrom
 *   - Required: No
 *   - Description: Filter tasks with due date from this date
 * 
 * @param {DATE} dueDateTo
 *   - Required: No
 *   - Description: Filter tasks with due date until this date
 * 
 * @returns Task list with details
 * 
 * @testScenarios
 * - List all tasks without filters
 * - Filter by status
 * - Filter by priority
 * - Filter by due date range
 * - Combined filters
 */
CREATE OR ALTER PROCEDURE [functional].[spTaskList]
  @idAccount INTEGER,
  @idUser INTEGER,
  @status INTEGER = NULL,
  @priority INTEGER = NULL,
  @dueDateFrom DATE = NULL,
  @dueDateTo DATE = NULL
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
   * @output {TaskList, n, n}
   * @column {INT} idTask - Task identifier
   * @column {NVARCHAR} title - Task title
   * @column {NVARCHAR} description - Task description
   * @column {DATE} dueDate - Due date
   * @column {TIME} dueTime - Due time
   * @column {INT} priority - Priority level
   * @column {INT} status - Task status
   * @column {INT} idCategory - Category identifier
   * @column {INT} estimatedTime - Estimated time in minutes
   * @column {INT} subtaskCount - Number of subtasks
   * @column {INT} completedSubtaskCount - Number of completed subtasks
   * @column {INT} attachmentCount - Number of attachments
   * @column {DATETIME2} dateCreated - Creation date
   * @column {DATETIME2} dateModified - Last modification date
   */
  SELECT
    [tsk].[idTask],
    [tsk].[title],
    [tsk].[description],
    [tsk].[dueDate],
    [tsk].[dueTime],
    [tsk].[priority],
    [tsk].[status],
    [tsk].[idCategory],
    [tsk].[estimatedTime],
    (
      SELECT COUNT(*)
      FROM [functional].[subtask] [sbtsk]
      WHERE [sbtsk].[idAccount] = [tsk].[idAccount]
        AND [sbtsk].[idTask] = [tsk].[idTask]
        AND [sbtsk].[deleted] = 0
    ) AS [subtaskCount],
    (
      SELECT COUNT(*)
      FROM [functional].[subtask] [sbtsk]
      WHERE [sbtsk].[idAccount] = [tsk].[idAccount]
        AND [sbtsk].[idTask] = [tsk].[idTask]
        AND [sbtsk].[completed] = 1
        AND [sbtsk].[deleted] = 0
    ) AS [completedSubtaskCount],
    (
      SELECT COUNT(*)
      FROM [functional].[taskAttachment] [tskAtt]
      WHERE [tskAtt].[idAccount] = [tsk].[idAccount]
        AND [tskAtt].[idTask] = [tsk].[idTask]
        AND [tskAtt].[deleted] = 0
    ) AS [attachmentCount],
    [tsk].[dateCreated],
    [tsk].[dateModified]
  FROM [functional].[task] [tsk]
  WHERE [tsk].[idAccount] = @idAccount
    AND [tsk].[idUser] = @idUser
    AND [tsk].[deleted] = 0
    AND (@status IS NULL OR [tsk].[status] = @status)
    AND (@priority IS NULL OR [tsk].[priority] = @priority)
    AND (@dueDateFrom IS NULL OR [tsk].[dueDate] >= @dueDateFrom)
    AND (@dueDateTo IS NULL OR [tsk].[dueDate] <= @dueDateTo)
  ORDER BY
    [tsk].[dueDate] ASC,
    [tsk].[priority] DESC,
    [tsk].[dateCreated] DESC;
END;
GO