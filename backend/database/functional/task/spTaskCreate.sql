/**
 * @summary
 * Creates a new task with basic information including title, description,
 * due date, priority, and optional category assignment.
 * 
 * @procedure spTaskCreate
 * @schema functional
 * @type stored-procedure
 * 
 * @endpoints
 * - POST /api/v1/internal/task
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
 *   - Required: No
 *   - Description: Priority level (0=low, 1=medium, 2=high)
 * 
 * @param {INT} idCategory
 *   - Required: No
 *   - Description: Category identifier
 * 
 * @param {INT} estimatedTime
 *   - Required: No
 *   - Description: Estimated time in minutes (5-1440)
 * 
 * @returns {INT} idTask - Created task identifier
 * 
 * @testScenarios
 * - Valid creation with only required fields
 * - Valid creation with all optional fields
 * - Validation failure for empty title
 * - Validation failure for title too short
 * - Validation failure for title too long
 * - Validation failure for past due date
 * - Validation failure for invalid priority
 * - Validation failure for invalid estimated time
 */
CREATE OR ALTER PROCEDURE [functional].[spTaskCreate]
  @idAccount INTEGER,
  @idUser INTEGER,
  @title NVARCHAR(100),
  @description NVARCHAR(1000) = '',
  @dueDate DATE = NULL,
  @dueTime TIME = NULL,
  @priority INTEGER = 1,
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
   * @validation Due date validation
   * @throw {dueDateMustBeFuture}
   */
  IF (@dueDate IS NOT NULL AND @dueDate < CAST(GETUTCDATE() AS DATE))
  BEGIN
    ;THROW 51000, 'dueDateMustBeFuture', 1;
  END;

  /**
   * @validation Priority validation
   * @throw {invalidPriority}
   */
  IF (@priority IS NOT NULL AND (@priority < 0 OR @priority > 2))
  BEGIN
    ;THROW 51000, 'invalidPriority', 1;
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

      DECLARE @idTask INTEGER;

      /**
       * @rule {fn-task-creation} Create new task with validated parameters
       */
      INSERT INTO [functional].[task] (
        [idAccount],
        [idUser],
        [title],
        [description],
        [dueDate],
        [dueTime],
        [priority],
        [status],
        [idCategory],
        [estimatedTime],
        [dateCreated],
        [dateModified]
      )
      VALUES (
        @idAccount,
        @idUser,
        @title,
        @description,
        @dueDate,
        @dueTime,
        @priority,
        0,
        @idCategory,
        @estimatedTime,
        GETUTCDATE(),
        GETUTCDATE()
      );

      SET @idTask = SCOPE_IDENTITY();

      /**
       * @output {TaskCreated, 1, 1}
       * @column {INT} idTask
       * - Description: Created task identifier
       */
      SELECT @idTask AS [idTask];

    COMMIT TRAN;
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
  END CATCH;
END;
GO