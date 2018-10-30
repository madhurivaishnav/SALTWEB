if not exists (select * from tblAppConfig where Name = 'TimeZone')
begin 

	insert into tblAppConfig (name, value) values('TimeZone','@@@VVV@@@')
	
end
GO