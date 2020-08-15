CREATE TABLE `options` (
  `idoptions` int NOT NULL AUTO_INCREMENT,
  `option_type` varchar(45) NOT NULL,
  `option_name` varchar(45) NOT NULL,
  `option_value` varchar(255) NOT NULL DEFAULT '',
  `descr` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`idoptions`),
  UNIQUE KEY `idxU` (`option_type`,`option_name`),
  KEY `idxOT` (`option_type`),
  KEY `idxON` (`option_name`),
  KEY `idxOV` (`option_value`)
) ENGINE=InnoDB;


CREATE FUNCTION option_add(
  otype VARCHAR(45),
  oname VARCHAR(45),
  ovalue VARCHAR(255),
  ds VARCHAR(255)
) RETURNS int
BEGIN
  declare ido int default 0;

  select idoptions into ido
  from `options`
  where option_type=otype and option_name=oname;

  if ido>0 then

    update `options`
    set option_value=ovalue, descr=ds
    where idoptions=ido;

  else

    set ido=last_insert_id(0);

    insert into `options`(option_type, option_name, option_value, descr)
    values (otype, oname, ovalue, ds);

    set ido=last_insert_id();

  end if;

  RETURN ido;
END


CREATE PROCEDURE `option_delete`(ido int)
BEGIN

  delete from `options`
  where idoptions=ido;

END


CREATE PROCEDURE `option_set_value`(
  ido int,
  ovalue VARCHAR(255)
)
BEGIN

  update `options`
  set option_value=ovalue
  where idoptions=ido;

END


CREATE FUNCTION `option_get_id`(
  otype VARCHAR(45),
  oname VARCHAR(45)
) RETURNS int
BEGIN
  declare ido int default -1;

  select idoptions into ido
  from `options`
  where option_type=otype and option_name=oname;

  RETURN ido;

END

CREATE FUNCTION `option_get_value`(ido int) RETURNS varchar(255)
BEGIN
  declare res VARCHAR(255) default '';

  select option_value into res
  from `options`
  where idoptions=ido;

  RETURN res;

END
