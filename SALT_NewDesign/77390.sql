If  exists (select * from tblLangValue where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/MyTraining.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'locDue')) 
begin 
update tblLangValue 
set LangEntryValue = N'Due'
where (LangID =2)
and (LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/MyTraining.aspx'))
and (LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'locDue'))
 end 
