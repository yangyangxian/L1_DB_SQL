--Email
  SELECT top 1111 msg.createdt,fds.createdt,msg.completiondt,fds.completiondt, *
  FROM EMAIL_MSG msg
  left JOIN dbo.FCS_DELIVERY_STATUS fds
  ON msg.EmId=fds.BusinessId and fds.BusinessType='EmailMsg'

  select ema.*,fds.* from email_msg em
  join EMAIL_MSG_ADDRESSING ema on em.EmId=ema.EmId
  join FCS_DELIVERY_STATUS fds ON em.EmId=fds.BusinessId

--Report
	--Standard Report Definition
	select top 1111 * from REPORT_DEF
	--Report request(run)
  select top 1111 * from REPORT_REQUEST
	where ReportName='Registration Detail'
	order by CreateDt desc
	--Custom Report Template
	select top 1111 * from REPORT_TEMPLATE rt
	left join REPORT_TEMPLATE_FIELD rtf
	on rt.ReportTemplateId = rtf.ReportTemplateId
	--Custom Report Fields(Dictionary)
	select top 1111 * from REPORT_TEMPLATE_FIELD_LIST

--Person
	--find the staff jobs which have job rights by its fusid
	select * from org_staff a
	inner join job b on a.jobid=b.jobid
	inner join job_right c on b.jobid=c.jobid
	inner join user_person d on a.adultid=d.personid
	inner join [user] e on d.userid=e.userid
	where e.fususerid='2a0d3f85-d1a7-4e3d-8359-14d6d68039f3'

--Policy
	--all the policies
	select top 11111 * from CLUB_POLICY
	--The policy associated to cpr
	select top 11111 * from CLUB_PLAYER_REG_POLICY

--OCS
  --Find ocs by its name and SeasonDescription
  select top 1111 * from OREG_COMP_SEASON where internalname='U05-U06 Youth Academy' and SeasonDescription='2016 - 2017 Fall'

  --Find the ocs season and session info
  DECLARE @ocsid int = 107333
  DECLARE @orgid int = (select top 1 clubid from OREG_COMP_SEASON where ocsid=@ocsid)
  DECLARE @parentorgid int = (select top 1 parentorgid from organization where orgid=@orgid)
  DECLARE @clubregistrationid int = (select top 1 clubregistrationid from OREG_COMP_SEASON where ocsid=@ocsid)
  DECLARE @parentorgsessionid int = (select top 1 parentorgsessionid from club_registration where clubregistrationid=@clubregistrationid)
  DECLARE @parentorgseasonid int = (select top 1 posnid from club_registration where clubregistrationid=@clubregistrationid)
  select * from organization where orgid=@orgid
  select * from OREG_COMP_SEASON where ocsid=@ocsid
  select * from club_registration where clubregistrationid=@clubregistrationid
  select * from parent_org_session where parentorgsessionid=@parentorgsessionid
  select * from parent_org_season where posnid=@parentorgseasonid

--Org
  --Find org by its name
  select top 1111 * from Organization where orgname='Rio Rapids SC'

--NCSA
  --The submmisions to ncsa
  SELECT * FROM dbo.NCSA_SUBMISSIONS AS ns

--Submit request
  --requests
  select top 111 * from handlers.REQUESTS
  --request definition
  select top 111 * from handlers.REQUEST_CHAIN_DEFS
  --request handler which is the handler to deal with the request
  select top 111 * from handlers.REQUEST_HANDLERS
  --request and its handler
  select top 111 * from handlers.REQUEST_HANDLERS rh
  join handlers.REQUEST_CHAIN_DEFS rcd on rh.requesthandlerid=rcd.StartingRequestHandlerid
  --request option definition
  select top 111 * from handlers.REQUEST_CHAIN_DEF_OPTION_DEFS
  --request options which are bind to request and is used to store some info for the request
  select top 111 * from handlers.REQUEST_CHAIN_DEF_OPTIONS

--Age Group
SELECT *
  FROM CLUB_AGE_GROUP cag
  left join PARENT_ORG_AGE_GROUP poag on cag.ParentOrgAgeGroupId=poag.ParentOrgAgeGroupId
  left join PARENT_ORG_reg_class porc on cag.PARENTORGregclassid=porc.PARENTORGregclassid
  where clubid=15992

--password Encrypt
	declare @pass varchar(100)
	exec @pass = dbo.fnGetDecryptedData 0x83D3A35CAE8A40A0936E8F88DE3AF965,1
  select @pass

  declare @pass varbinary(100)
  exec @pass = dbo.fnGetEncryptedData_password '@ctive123'
  select @pass

--Registration and payment
  select top 11 * from OREG_COLLECTION order by oregcollid desc 

--Payment info by CPR id
declare @cprid int =12437793
declare @ocaid int
declare @financialtransactionid int
select * from club_player_registration where clubplayerregistrationid=@cprid
select @ocaid=ocaid from REGISTRATION_FULL_INFOS where cprid=@cprid
select * from REGISTRATION_FULL_INFOS where cprid=@cprid
select * from oreg_card_attempt where ocaid=@ocaid
select * from oreg_collection where ocaid=@ocaid
select * from financial_transaction where businessid= @cprid
select @financialtransactionid=transactionid from financial_transaction where businessid= @cprid
select * from payment_detail where ocaid=@ocaid
select * from FINANCIAL_TRANSACTION_DETAIL where transactionid=@financialtransactionid

--Active admin user list
SELECT DISTINCT u.UserId,u.EmailAddress,p.PersonId,p.LastName,p.FirstName,p.HomeEmailAddress,u.Password,u.FusUserId,u.LastLogonTm,u.CreateDt
FROM dbo.PERSON AS p WITH(NOLOCK) 
INNER JOIN dbo.USER_PERSON up WITH(NOLOCK) ON up.PersonId = p.PersonId
INNER JOIN dbo.[USER] u WITH(NOLOCK) ON u.UserId = up.UserId
WHERE AdminInd = 1 
UNION
SELECT distinct u.UserId,u.EmailAddress,p.PersonId,p.LastName,p.FirstName,p.HomeEmailAddress,u.Password,u.FusUserId,u.LastLogonTm,u.CreateDt 
FROM ORG_STAFF os  WITH(NOLOCK)
INNER JOIN dbo.JOB AS j  WITH(NOLOCK)ON os.JobId = j.JobId
INNER JOIN JOB_PROFILE_RIGHT jar  WITH(NOLOCK) ON j.JobProfileId = jar.JobProfileId
INNER JOIN dbo.RIGHT_DEF AS rd  WITH(NOLOCK) ON jar.RightId = rd.RightId
INNER JOIN dbo.PERSON p  WITH(NOLOCK) ON p.PersonId = os.AdultId AND p.AdminInd <> 1
INNER JOIN dbo.USER_PERSON up WITH(NOLOCK) ON up.PersonId = p.PersonId
INNER JOIN dbo.[USER] u WITH(NOLOCK) ON u.UserId = up.UserId
WHERE rd.RightCd = 'SAD'