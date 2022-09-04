import std.stdio;
import delta_time;
import Math = math;

void main() {
    int tests = 0;

    double yaw = 0;

    double origin = 0;
    double destination = 0;
    double progress = 0;

    double internalSpeedMultiplier = 0.0;

    // This multiplier can be controlled based on how fast you want the object to interpolate
    double speedMultiplier = 3.0;

    bool doNew = true;

    // These variable are soley used for testing!
    double diff = 0.0;
    double accumulator = 0.0;

    // This should be an entity switch if it gets a new position
    while(tests < 20) {
        calculateDelta();

        if (doNew) {
            writeln("--------------------------------------------");
            writeln("TEST ", tests);
            writeln("--------------------------------------------");


            progress = 0.0;
            origin = yaw;
            destination = (Math.random() * 360.0) - 180.0;
            doNew = false;
            accumulator = 0.0;

            diff = Math.abs(origin) + Math.abs(destination);

            // writeln("the test: ", internalSpeedMultiplier);

            if (diff >= 180.0) {
                // writeln("overshooting");
                // Overshoot it and correct later
                // The signum is a multiplier based on if it's negative or positive (is 1 or -1)
                // writeln("original destination: ", destination);
                double signum = Math.signum(destination);
                destination = (Math.abs(destination) + 180.0) * signum;
                // writeln("corrected destination: ", destination);
            } else {
                // writeln("not overshooting");
            }

            
            double correctedDiff = Math.abs(Math.abs(origin) - Math.abs(destination));

            // Now correct it more, in case of a small window where it can dead lock
            if (correctedDiff == 0.0) {
                correctedDiff = 0.1;
            }

            // Keep the rotational speed constant
            internalSpeedMultiplier = Math.abs(1.0 - (correctedDiff / 360.0)) * speedMultiplier;
            writeln("corrected diff is: ", correctedDiff);
            writeln("speed multiplier = ", internalSpeedMultiplier);
        }

        accumulator += getDelta();

        // In production, STOP doing the interpolation
        // Perhaps give the entity object a bool that is "interpolateNow"?
        if (progress >= 1.0) {
            progress = 1.0;
            doNew = true;
            tests++;
        } else {
            // Goal has not been reached
            // This is the progress of the linear interpolation
            progress += getDelta() * internalSpeedMultiplier;
        }

        yaw = Math.lerp(origin, destination, progress);
        
        // This is the overshoot correction
        yawCorrection(yaw);

        if (progress == 1.0) {
            writeln("--------------------------------------------");
            writeln("Destination reached! Destination was: ", destination);
            writeln("The real yaw is now: ", yaw);
            writeln("The diff was: ", diff);
            writeln("It took roughtly: ", accumulator, " seconds");
            writeln("--------------------------------------------");
        }

        // Uncomment this to see live info on yaw
        // writeln("yaw is: ", yaw);

        assert(yaw >= -180.0 && yaw <= 180.0, "you done goofed");

        // Corrected value is what the rest of the program has accessed to (-180.0 to 180.0)
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
