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
