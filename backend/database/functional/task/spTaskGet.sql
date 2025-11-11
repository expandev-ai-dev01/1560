/**
 * @summary
 * Retrieves detailed information about a specific task including
 * subtasks, tags, and attachments.
 * 
 * @procedure spTaskGet
 * @schema functional
 * @type stored-procedure
 * 
 * @endpoints
 * - GET /api/v1/internal/task/:id
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
 * @returns Task details with related data
 * 
 * @testScenarios
 * - Valid task retrieval
 * - Task not found
 * - Access denied for different user
 */
CREATE OR ALTER PROCEDURE [functional].[spTaskGet]
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

  /**
   * @output {TaskDetails, 1, n}
   * @column {INT} idTask - Task identifier
   * @column {NVARCHAR} title - Task title
   * @column {NVARCHAR} description - Task description
   * @column {DATE} dueDate - Due date
   * @column {TIME} dueTime - Due time
   * @column {INT} priority - Priority level
   * @column {INT} status - Task status
   * @column {INT} idCategory - Category identifier
   * @column {INT} estimatedTime - Estimated time in minutes
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
    [tsk].[dateCreated],
    [tsk].[dateModified]
  FROM [functional].[task] [tsk]
  WHERE [tsk].[idTask] = @idTask
    AND [tsk].[idAccount] = @idAccount
    AND [tsk].[deleted] = 0;

  /**
   * @output {Subtasks, n, n}
   * @column {INT} idSubtask - Subtask identifier
   * @column {NVARCHAR} title - Subtask title
   * @column {BIT} completed - Completion status
   * @column {DATETIME2} dateCreated - Creation date
   */
  SELECT
    [sbtsk].[idSubtask],
    [sbtsk].[title],
    [sbtsk].[completed],
    [sbtsk].[dateCreated]
  FROM [functional].[subtask] [sbtsk]
  WHERE [sbtsk].[idTask] = @idTask
    AND [sbtsk].[idAccount] = @idAccount
    AND [sbtsk].[deleted] = 0
  ORDER BY [sbtsk].[dateCreated] ASC;

  /**
   * @output {Tags, n, n}
   * @column {NVARCHAR} tag - Tag name
   */
  SELECT
    [tskTag].[tag]
  FROM [functional].[taskTag] [tskTag]
  WHERE [tskTag].[idTask] = @idTask
    AND [tskTag].[idAccount] = @idAccount
  ORDER BY [tskTag].[tag] ASC;

  /**
   * @output {Attachments, n, n}
   * @column {INT} idAttachment - Attachment identifier
   * @column {NVARCHAR} fileName - File name
   * @column {VARCHAR} fileType - File type
   * @column {INT} fileSize - File size in bytes
   * @column {DATETIME2} dateCreated - Upload date
   */
  SELECT
    [tskAtt].[idAttachment],
    [tskAtt].[fileName],
    [tskAtt].[fileType],
    [tskAtt].[fileSize],
    [tskAtt].[dateCreated]
  FROM [functional].[taskAttachment] [tskAtt]
  WHERE [tskAtt].[idTask] = @idTask
    AND [tskAtt].[idAccount] = @idAccount
    AND [tskAtt].[deleted] = 0
  ORDER BY [tskAtt].[dateCreated] ASC;
END;
GO