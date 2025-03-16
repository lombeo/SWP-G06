-- Create the feedback table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[feedback]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[feedback](
    [id] [int] IDENTITY(1,1) NOT NULL,
    [review_id] [int] NOT NULL,
    [account_id] [int] NOT NULL,
    [feedback] [nvarchar](1000) NOT NULL,
    CONSTRAINT [PK_feedback] PRIMARY KEY CLUSTERED 
    (
        [id] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
    CONSTRAINT [FK_feedback_review] FOREIGN KEY ([review_id]) REFERENCES [dbo].[review] ([id]),
    CONSTRAINT [FK_feedback_account] FOREIGN KEY ([account_id]) REFERENCES [dbo].[account] ([id])
) ON [PRIMARY]
END
GO

-- Add index for faster lookup of feedback by review_id
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_feedback_review_id')
BEGIN
    CREATE NONCLUSTERED INDEX [IX_feedback_review_id] ON [dbo].[feedback]
    (
        [review_id] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
GO 