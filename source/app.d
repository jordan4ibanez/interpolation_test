import std.stdio;
import Math = math;

void main() {
    int tests = 0;
    double yaw = 0;
    double goal = 0;
    bool doNew = true;

    while(tests < 20) {

        if (doNew) {
            goal = (Math.random() * 360.0) - 180.0;
            doNew = false;
        }

        yaw = Math.lerp(yaw, goal, 1.0);

        yawCorrection(yaw);

        writeln("yaw is: ", yaw);

        assert(yaw >= -180.0 && yaw <= 180.0, "you done goofed");
    }
	
}

void yawCorrection(ref double yaw) {
    if (yaw < -180.0) {
        yaw += 360.0;
        writeln("yaw has underflowed ---------");
    } else if (yaw > 180.0) {
        yaw -= 360.0;
        writeln("yaw has overflowed +++++++++");
    }
}
