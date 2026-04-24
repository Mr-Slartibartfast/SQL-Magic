USE SSISDB;

GO

 

SELECT

    prj.name                AS ProjectName,

    op.object_name          AS PackageName,

    op.parameter_name       AS ParameterName,

    op.design_default_value AS DesignTimeValue

FROM catalog.object_parameters op

JOIN catalog.projects prj

  ON op.project_id = prj.project_id

WHERE op.parameter_name LIKE '%ConnectionString%'

ORDER BY prj.name, op.object_name, op.parameter_name;