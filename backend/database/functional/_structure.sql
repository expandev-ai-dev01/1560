/**
 * @schema functional
 * Business logic schema for task management system
 */
CREATE SCHEMA [functional];
GO

/**
 * @table task Task management table
 * @multitenancy true
 * @softDelete true
 * @alias tsk
 */
CREATE TABLE [functional].[task] (
  [idTask] INTEGER IDENTITY(1, 1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [idUser] INTEGER NOT NULL,
  [title] NVARCHAR(100) NOT NULL,
  [description] NVARCHAR(1000) NOT NULL DEFAULT (''),
  [dueDate] DATE NULL,
  [dueTime] TIME NULL,
  [priority] INTEGER NOT NULL DEFAULT (1),
  [status] INTEGER NOT NULL DEFAULT (0),
  [idCategory] INTEGER NULL,
  [estimatedTime] INTEGER NULL,
  [dateCreated] DATETIME2 NOT NULL DEFAULT (GETUTCDATE()),
  [dateModified] DATETIME2 NOT NULL DEFAULT (GETUTCDATE()),
  [deleted] BIT NOT NULL DEFAULT (0)
);
GO

/**
 * @table subtask Subtask management table
 * @multitenancy true
 * @softDelete true
 * @alias sbtsk
 */
CREATE TABLE [functional].[subtask] (
  [idSubtask] INTEGER IDENTITY(1, 1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [idTask] INTEGER NOT NULL,
  [title] NVARCHAR(50) NOT NULL,
  [completed] BIT NOT NULL DEFAULT (0),
  [dateCreated] DATETIME2 NOT NULL DEFAULT (GETUTCDATE()),
  [dateModified] DATETIME2 NOT NULL DEFAULT (GETUTCDATE()),
  [deleted] BIT NOT NULL DEFAULT (0)
);
GO

/**
 * @table taskTag Task tags relationship table
 * @multitenancy true
 * @softDelete false
 * @alias tskTag
 */
CREATE TABLE [functional].[taskTag] (
  [idAccount] INTEGER NOT NULL,
  [idTask] INTEGER NOT NULL,
  [tag] NVARCHAR(20) NOT NULL,
  [dateCreated] DATETIME2 NOT NULL DEFAULT (GETUTCDATE())
);
GO

/**
 * @table taskAttachment Task attachments table
 * @multitenancy true
 * @softDelete true
 * @alias tskAtt
 */
CREATE TABLE [functional].[taskAttachment] (
  [idAttachment] INTEGER IDENTITY(1, 1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [idTask] INTEGER NOT NULL,
  [fileName] NVARCHAR(255) NOT NULL,
  [fileType] VARCHAR(50) NOT NULL,
  [fileSize] INTEGER NOT NULL,
  [filePath] NVARCHAR(500) NOT NULL,
  [dateCreated] DATETIME2 NOT NULL DEFAULT (GETUTCDATE()),
  [deleted] BIT NOT NULL DEFAULT (0)
);
GO

/**
 * @table taskRecurrence Task recurrence configuration table
 * @multitenancy true
 * @softDelete true
 * @alias tskRec
 */
CREATE TABLE [functional].[taskRecurrence] (
  [idRecurrence] INTEGER IDENTITY(1, 1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [idTask] INTEGER NOT NULL,
  [periodicity] INTEGER NOT NULL,
  [daysOfWeek] VARCHAR(20) NULL,
  [dayOfMonth] INTEGER NULL,
  [customInterval] INTEGER NULL,
  [startDate] DATE NOT NULL,
  [endDate] DATE NULL,
  [occurrences] INTEGER NULL,
  [dateCreated] DATETIME2 NOT NULL DEFAULT (GETUTCDATE()),
  [deleted] BIT NOT NULL DEFAULT (0)
);
GO

/**
 * @table taskTemplate Task template table
 * @multitenancy true
 * @softDelete true
 * @alias tskTpl
 */
CREATE TABLE [functional].[taskTemplate] (
  [idTemplate] INTEGER IDENTITY(1, 1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [idUser] INTEGER NOT NULL,
  [name] NVARCHAR(50) NOT NULL,
  [title] NVARCHAR(100) NOT NULL,
  [description] NVARCHAR(1000) NOT NULL DEFAULT (''),
  [priority] INTEGER NOT NULL DEFAULT (1),
  [estimatedTime] INTEGER NULL,
  [dateCreated] DATETIME2 NOT NULL DEFAULT (GETUTCDATE()),
  [deleted] BIT NOT NULL DEFAULT (0)
);
GO

/**
 * @primaryKey pkTask
 * @keyType Object
 */
ALTER TABLE [functional].[task]
ADD CONSTRAINT [pkTask] PRIMARY KEY CLUSTERED ([idTask]);
GO

/**
 * @primaryKey pkSubtask
 * @keyType Object
 */
ALTER TABLE [functional].[subtask]
ADD CONSTRAINT [pkSubtask] PRIMARY KEY CLUSTERED ([idSubtask]);
GO

/**
 * @primaryKey pkTaskTag
 * @keyType Relationship
 */
ALTER TABLE [functional].[taskTag]
ADD CONSTRAINT [pkTaskTag] PRIMARY KEY CLUSTERED ([idAccount], [idTask], [tag]);
GO

/**
 * @primaryKey pkTaskAttachment
 * @keyType Object
 */
ALTER TABLE [functional].[taskAttachment]
ADD CONSTRAINT [pkTaskAttachment] PRIMARY KEY CLUSTERED ([idAttachment]);
GO

/**
 * @primaryKey pkTaskRecurrence
 * @keyType Object
 */
ALTER TABLE [functional].[taskRecurrence]
ADD CONSTRAINT [pkTaskRecurrence] PRIMARY KEY CLUSTERED ([idRecurrence]);
GO

/**
 * @primaryKey pkTaskTemplate
 * @keyType Object
 */
ALTER TABLE [functional].[taskTemplate]
ADD CONSTRAINT [pkTaskTemplate] PRIMARY KEY CLUSTERED ([idTemplate]);
GO

/**
 * @foreignKey fkTask_Account Account isolation for tasks
 * @target subscription.account
 * @tenancy true
 */
ALTER TABLE [functional].[task]
ADD CONSTRAINT [fkTask_Account] FOREIGN KEY ([idAccount])
REFERENCES [subscription].[account]([idAccount]);
GO

/**
 * @foreignKey fkTask_User Task owner reference
 * @target security.user
 */
ALTER TABLE [functional].[task]
ADD CONSTRAINT [fkTask_User] FOREIGN KEY ([idUser])
REFERENCES [security].[user]([idUser]);
GO

/**
 * @foreignKey fkSubtask_Account Account isolation for subtasks
 * @target subscription.account
 * @tenancy true
 */
ALTER TABLE [functional].[subtask]
ADD CONSTRAINT [fkSubtask_Account] FOREIGN KEY ([idAccount])
REFERENCES [subscription].[account]([idAccount]);
GO

/**
 * @foreignKey fkSubtask_Task Parent task reference
 * @target functional.task
 */
ALTER TABLE [functional].[subtask]
ADD CONSTRAINT [fkSubtask_Task] FOREIGN KEY ([idTask])
REFERENCES [functional].[task]([idTask]);
GO

/**
 * @foreignKey fkTaskTag_Account Account isolation for task tags
 * @target subscription.account
 * @tenancy true
 */
ALTER TABLE [functional].[taskTag]
ADD CONSTRAINT [fkTaskTag_Account] FOREIGN KEY ([idAccount])
REFERENCES [subscription].[account]([idAccount]);
GO

/**
 * @foreignKey fkTaskTag_Task Task reference for tags
 * @target functional.task
 */
ALTER TABLE [functional].[taskTag]
ADD CONSTRAINT [fkTaskTag_Task] FOREIGN KEY ([idTask])
REFERENCES [functional].[task]([idTask]);
GO

/**
 * @foreignKey fkTaskAttachment_Account Account isolation for attachments
 * @target subscription.account
 * @tenancy true
 */
ALTER TABLE [functional].[taskAttachment]
ADD CONSTRAINT [fkTaskAttachment_Account] FOREIGN KEY ([idAccount])
REFERENCES [subscription].[account]([idAccount]);
GO

/**
 * @foreignKey fkTaskAttachment_Task Task reference for attachments
 * @target functional.task
 */
ALTER TABLE [functional].[taskAttachment]
ADD CONSTRAINT [fkTaskAttachment_Task] FOREIGN KEY ([idTask])
REFERENCES [functional].[task]([idTask]);
GO

/**
 * @foreignKey fkTaskRecurrence_Account Account isolation for recurrence
 * @target subscription.account
 * @tenancy true
 */
ALTER TABLE [functional].[taskRecurrence]
ADD CONSTRAINT [fkTaskRecurrence_Account] FOREIGN KEY ([idAccount])
REFERENCES [subscription].[account]([idAccount]);
GO

/**
 * @foreignKey fkTaskRecurrence_Task Task reference for recurrence
 * @target functional.task
 */
ALTER TABLE [functional].[taskRecurrence]
ADD CONSTRAINT [fkTaskRecurrence_Task] FOREIGN KEY ([idTask])
REFERENCES [functional].[task]([idTask]);
GO

/**
 * @foreignKey fkTaskTemplate_Account Account isolation for templates
 * @target subscription.account
 * @tenancy true
 */
ALTER TABLE [functional].[taskTemplate]
ADD CONSTRAINT [fkTaskTemplate_Account] FOREIGN KEY ([idAccount])
REFERENCES [subscription].[account]([idAccount]);
GO

/**
 * @foreignKey fkTaskTemplate_User Template owner reference
 * @target security.user
 */
ALTER TABLE [functional].[taskTemplate]
ADD CONSTRAINT [fkTaskTemplate_User] FOREIGN KEY ([idUser])
REFERENCES [security].[user]([idUser]);
GO

/**
 * @check chkTask_Priority Priority validation
 * @enum {0} Low priority
 * @enum {1} Medium priority
 * @enum {2} High priority
 */
ALTER TABLE [functional].[task]
ADD CONSTRAINT [chkTask_Priority] CHECK ([priority] BETWEEN 0 AND 2);
GO

/**
 * @check chkTask_Status Status validation
 * @enum {0} Pending
 * @enum {1} In progress
 * @enum {2} Completed
 * @enum {3} Cancelled
 */
ALTER TABLE [functional].[task]
ADD CONSTRAINT [chkTask_Status] CHECK ([status] BETWEEN 0 AND 3);
GO

/**
 * @check chkTaskRecurrence_Periodicity Periodicity validation
 * @enum {0} Daily
 * @enum {1} Weekly
 * @enum {2} Monthly
 * @enum {3} Custom
 */
ALTER TABLE [functional].[taskRecurrence]
ADD CONSTRAINT [chkTaskRecurrence_Periodicity] CHECK ([periodicity] BETWEEN 0 AND 3);
GO

/**
 * @index ixTask_Account Account isolation index
 * @type ForeignKey
 */
CREATE NONCLUSTERED INDEX [ixTask_Account]
ON [functional].[task]([idAccount])
WHERE [deleted] = 0;
GO

/**
 * @index ixTask_User User tasks index
 * @type ForeignKey
 */
CREATE NONCLUSTERED INDEX [ixTask_User]
ON [functional].[task]([idAccount], [idUser])
WHERE [deleted] = 0;
GO

/**
 * @index ixTask_DueDate Due date search index
 * @type Search
 */
CREATE NONCLUSTERED INDEX [ixTask_DueDate]
ON [functional].[task]([idAccount], [dueDate])
INCLUDE ([title], [priority], [status])
WHERE [deleted] = 0;
GO

/**
 * @index ixTask_Status Status filtering index
 * @type Search
 */
CREATE NONCLUSTERED INDEX [ixTask_Status]
ON [functional].[task]([idAccount], [status])
INCLUDE ([title], [dueDate], [priority])
WHERE [deleted] = 0;
GO

/**
 * @index ixSubtask_Task Parent task index
 * @type ForeignKey
 */
CREATE NONCLUSTERED INDEX [ixSubtask_Task]
ON [functional].[subtask]([idAccount], [idTask])
WHERE [deleted] = 0;
GO

/**
 * @index ixTaskTag_Task Task tags index
 * @type ForeignKey
 */
CREATE NONCLUSTERED INDEX [ixTaskTag_Task]
ON [functional].[taskTag]([idAccount], [idTask]);
GO

/**
 * @index ixTaskAttachment_Task Task attachments index
 * @type ForeignKey
 */
CREATE NONCLUSTERED INDEX [ixTaskAttachment_Task]
ON [functional].[taskAttachment]([idAccount], [idTask])
WHERE [deleted] = 0;
GO

/**
 * @index ixTaskRecurrence_Task Task recurrence index
 * @type ForeignKey
 */
CREATE NONCLUSTERED INDEX [ixTaskRecurrence_Task]
ON [functional].[taskRecurrence]([idAccount], [idTask])
WHERE [deleted] = 0;
GO

/**
 * @index ixTaskTemplate_User User templates index
 * @type ForeignKey
 */
CREATE NONCLUSTERED INDEX [ixTaskTemplate_User]
ON [functional].[taskTemplate]([idAccount], [idUser])
WHERE [deleted] = 0;
GO

/**
 * @index uqTaskTemplate_Name Unique template name per user
 * @type Unique
 * @unique true
 */
CREATE UNIQUE NONCLUSTERED INDEX [uqTaskTemplate_Name]
ON [functional].[taskTemplate]([idAccount], [idUser], [name])
WHERE [deleted] = 0;
GO