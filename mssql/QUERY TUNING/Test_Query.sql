SELECT TOP (20) 
	[Extent1].[PostId] as [PostId],
	[Extent1].[AnswerCount] as [AnswerCount],
	[Extent1].[ViewCount] as [ViewCount],
	[Extent1].[Title] as [Title],
	[Extent1].[Tags] as [Tags],
	[Extent2].[UserId] as [UserId],
	[Extent2].[DisplayName] as [DisplayName],
	[Extent2].[Reputation] as [Reputation]
FROM [dbo].[Posts] as [Extent1]
	INNER JOIN [dbo].[Users] AS [Extent2] ON [Extent1].[OwnerUserId] = [Extent2].[UserId]
WHERE [Extent1].[PostTypeId] = 1  
ORDER BY [Extent1].[CreationDate] DESC

