declare @P1 int
exec prcCourse_Create @intCourseID = @P1 output, 
@name = 'Stress In The Workplace', 
@notes = 'This is a short course on Stress in the Workplace', @active = 1, @userID = 1

exec prcCourse_Create @intCourseID = @P1 output, 
@name = 'Harassment In The Workplace', 
@notes = 'This is a short course on Harassment in the Workplace', @active = 1, @userID = 1

exec prcCourse_Create @intCourseID = @P1 output, 
@name = 'Diversity In The Workplace', 
@notes = 'This is a short course on Diversity in the Workplace', @active = 1, @userID = 1

exec prcCourse_Create @intCourseID = @P1 output, 
@name = 'Workplace Management', 
@notes = 'This is a short course on Workplace Management', @active = 1, @userID = 1

exec prcCourse_Create @intCourseID = @P1 output, 
@name = 'Performance Management', 
@notes = 'This is a short course on Performance Management', @active = 1, @userID = 1 

exec prcModule_Create @courseID = 1, @name = 'Stress Introductory Module', @description = 'This is an introductory module.', @active = 0, @userID = 1
exec prcModule_Create @courseID = 2, @name = 'Harassment Introductory Module', @description = 'This is an introductory module.', @active = 0, @userID = 1
exec prcModule_Create @courseID = 3, @name = 'Diversity Introductory Module', @description = 'This is an introductory module.', @active = 0, @userID = 1
exec prcModule_Create @courseID = 4, @name = 'Management Introductory Module', @description = 'This is an introductory module.', @active = 0, @userID = 1
exec prcModule_Create @courseID = 5, @name = 'Performance Introductory Module', @description = 'This is an introductory module.', @active = 0, @userID = 1

exec prcModule_Create @courseID = 1, @name = 'Stress Intermediate Module', @description = 'This is an Intermediate module.', @active = 0, @userID = 1
exec prcModule_Create @courseID = 2, @name = 'Harassment Intermediate Module', @description = 'This is an Intermediate module.', @active = 0, @userID = 1
exec prcModule_Create @courseID = 3, @name = 'Diversity Intermediate Module', @description = 'This is an Intermediate module.', @active = 0, @userID = 1
exec prcModule_Create @courseID = 4, @name = 'Management Intermediate Module', @description = 'This is an Intermediate module.', @active = 0, @userID = 1
exec prcModule_Create @courseID = 5, @name = 'Performance Intermediate Module', @description = 'This is an Intermediate module.', @active = 0, @userID = 1

exec prcModule_Create @courseID = 1, @name = 'Stress Advanced Module', @description = 'This is an Advanced module.', @active = 0, @userID = 1
exec prcModule_Create @courseID = 2, @name = 'Harassment Advanced Module', @description = 'This is an Advanced module.', @active = 0, @userID = 1
exec prcModule_Create @courseID = 3, @name = 'Diversity Advanced Module', @description = 'This is an Advanced module.', @active = 0, @userID = 1
exec prcModule_Create @courseID = 4, @name = 'Management Advanced Module', @description = 'This is an Advanced module.', @active = 0, @userID = 1
exec prcModule_Create @courseID = 5, @name = 'Performance Advanced Module', @description = 'This is an Advanced module.', @active = 0, @userID = 1
