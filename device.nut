//Servo controller turns http calls into servo movement.
 
g_minDutyCycle <- 0.02
g_maxDutyCycle <- 0.13
g_position <- 0.0;
 
// Convert a position value between 0.0 and 1.0 to a duty cycle for the PWM.
function pos2dc( value )
{
    return g_minDutyCycle + (value*(g_maxDutyCycle-g_minDutyCycle));
}
 
function move_1_to( pos )
{
    g_position = pos;
    hardware.pin1.write( pos2dc(g_position) );
    server.log(format("Servo moved to %.2f, duty cycle=%.3f", g_position, pos2dc(g_position)));
    imp.sleep(2.0);
    local position = hardware.pin8.read();
    server.log(position);
}
function move_2_to( pos )
{
    g_position = pos;
    hardware.pin2.write( pos2dc(g_position) );
    server.log(format("Servo moved to %.2f, duty cycle=%.3f", g_position, pos2dc(g_position)));
    imp.sleep(2.0);
    local position = hardware.pin9.read();
    server.log(position);
} 

// Handlers for messages from the Agent.
agent.on("pan", function(data) {
    move_1_to(data.tofloat()/100);
    server.log("Pan value: " + data);
    });
agent.on("tilt", function(data) {
    move_2_to(data.tofloat()/100);
    server.log("Tilt value: " + data);
    });
function configureHardware()
{
    hardware.pin1.configure(PWM_OUT, 0.02, pos2dc(g_position));
    hardware.pin2.configure(PWM_OUT, 0.02, pos2dc(g_position));
    hardware.pin8.configure(ANALOG_IN);
    hardware.pin9.configure(ANALOG_IN);
    server.log("Hardware Configured");
}
imp.configure("Servo Control", [], []);
configureHardware();
move_1_to(0.5);//Center Servo 1
move_2_to(0.5);//Center Servo 2    
