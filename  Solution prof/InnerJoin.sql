
USE AdventureWorks2017

IF object_id('tempdb.dbo.#temp1') is not null drop table #temp1
---DROP TABLE #temp1
SELECT
HumanResources.Department.DepartmentID AS DEPDepartmentID,
HumanResources.Department.Name AS DEPName,
HumanResources.Department.GroupName,
HumanResources.Department.ModifiedDate AS DEPModifiedDate,
HumanResources.EmployeeDepartmentHistory.BusinessEntityID AS DEPBusinessEntityID,
HumanResources.EmployeeDepartmentHistory.DepartmentID AS EMPDepartmentID,
HumanResources.EmployeeDepartmentHistory.ShiftID AS EMPShiftID,
HumanResources.EmployeeDepartmentHistory.StartDate,
HumanResources.EmployeeDepartmentHistory.EndDate,
HumanResources.EmployeeDepartmentHistory.ModifiedDate AS EMPDEPModifiedDate,
HumanResources.Employee.BusinessEntityID AS EMPBusinessEntityID,
HumanResources.Employee.NationalIDNumber,
HumanResources.Employee.LoginID,
HumanResources.Employee.OrganizationNode,
HumanResources.Employee.OrganizationLevel,
HumanResources.Employee.JobTitle,
HumanResources.Employee.BirthDate,
HumanResources.Employee.MaritalStatus,
HumanResources.Employee.Gender,
HumanResources.Employee.HireDate,
HumanResources.Employee.SalariedFlag,
HumanResources.Employee.VacationHours,
HumanResources.Employee.SickLeaveHours,
HumanResources.Employee.CurrentFlag,
HumanResources.Employee.rowguid,
HumanResources.Employee.ModifiedDate AS EMPModifiedDate,
HumanResources.EmployeePayHistory.BusinessEntityID AS PAYBusinessEntityID,
HumanResources.EmployeePayHistory.RateChangeDate,
HumanResources.EmployeePayHistory.Rate,
HumanResources.EmployeePayHistory.PayFrequency,
HumanResources.EmployeePayHistory.ModifiedDate AS PAYModifiedDate,
HumanResources.JobCandidate.JobCandidateID,
HumanResources.JobCandidate.BusinessEntityID AS CANBusinessEntityID,
HumanResources.JobCandidate.ModifiedDate AS CANModifiedDate,
HumanResources.Shift.ShiftID AS SHIShiftID,
HumanResources.Shift.Name AS SHIName,
HumanResources.Shift.StartTime,
HumanResources.Shift.EndTime,
HumanResources.Shift.ModifiedDate AS SHIModifiedDate
INTO #temp1
FROM HumanResources.Department
INNER JOIN HumanResources.EmployeeDepartmentHistory ON HumanResources.Department.DepartmentID = HumanResources.EmployeeDepartmentHistory.DepartmentID
INNER JOIN HumanResources.Employee ON HumanResources.EmployeeDepartmentHistory.BusinessEntityID = HumanResources.Employee.BusinessEntityID
INNER JOIN HumanResources.EmployeePayHistory ON HumanResources.Employee.BusinessEntityID = HumanResources.EmployeePayHistory.BusinessEntityID
LEFT OUTER JOIN HumanResources.JobCandidate ON HumanResources.Employee.BusinessEntityID = HumanResources.JobCandidate.BusinessEntityID
LEFT OUTER JOIN HumanResources.Shift ON HumanResources.EmployeeDepartmentHistory.ShiftID = HumanResources.Shift.ShiftID
select * from #temp1
