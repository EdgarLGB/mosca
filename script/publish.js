// Wrap the script in a method, so that you can do "return false;" in case of an error or stop request
function publish()
{
    var Thread = Java.type("java.lang.Thread");

    for (i = 0; i < 10; i++)
    {
        mqttspy.publish("gaoying", "hello" + i);

        // Make sure you wrap the Thread.sleep in try/catch, and do return on exception
        try 
        {
            Thread.sleep(1000);
        }
        catch(err) 
        {
            return false;               
        }
    }

    // This means all OK, script has completed without any issues and as expected
    return true;
}

publish();