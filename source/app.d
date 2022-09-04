import std.stdio;
import delta_time;
import Math = math;

void main() {
    int tests = 0;

    double yaw = 0;

    double origin = 0;
    double destination = 0;
    double progress = 0;

    bool doNew = true;

    // This should be an entity switch if it gets a new position
    while(tests < 20) {
        assert(Math.random() != 1);
        calculateDelta();

        if (doNew) {
            progress = 0.0;
            origin = yaw;
            destination = (Math.random() * 360.0) - 180.0;
            doNew = false;

            if (Math.abs(origin) + Math.abs(destination) >= 180.0) {
                writeln("overshooting");
                // Overshoot it and correct later
                // The signum is a multiplier based on if it's negative or positive (is 1 or -1)
                writeln("original destination: ", destination);
                double signum = Math.signum(destination);
                destination = (Math.abs(destination) + 180.0) * signum;
                writeln("corrected destination: ", destination);
            } else {
                writeln("not overshooting");
            }
        }

        // In production, STOP doing the interpolation
        // Perhaps give the entity object a bool that is "interpolateNow"?
        if (progress >= 1.0) {
            progress = 1.0;
            doNew = true;
        } else {
            // Goal has not been reached
            // This is the progress of the linear interpolation
            progress += getDelta();
        }

        yaw = Math.lerp(origin, destination, progress);

        // writeln(yaw);
        
        // This is the overshoot correction
        yawCorrection(yaw);

        if (progress == 1.0) {
            writeln("--------------------------------------------");
            writeln("Destination reached! Destination was: ", destination);
            writeln("The real yaw is now: ", yaw);
            writeln("--------------------------------------------");
        }

        writeln("yaw is: ", yaw);

        assert(yaw >= -180.0 && yaw <= 180.0, "you done goofed");

        // Corrected value is what the rest of the value has accessed to (-180.0 to 180.0)
    }
	
}

void yawCorrection(ref double yaw) {
    if (yaw < -180.0) {
        yaw += 360.0;
        // writeln("yaw has underflowed ---------");
    } else if (yaw > 180.0) {
        yaw -= 360.0;
        // writeln("yaw has overflowed +++++++++");
    }
}
