-- SELECT ALL messages 
-- FROM the iot hub and put them
-- INTO the sql database
SELECT
    deviceID,
    [timestamp] as [timestamp],
    temperature
INTO
    sqldb
FROM
    iothub
