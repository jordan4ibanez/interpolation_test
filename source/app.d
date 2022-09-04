import std.stdio;
import delta_time;
import Math = math;


// This is a completely structural functional yaw interpolation implementation
// Yaws range -180.0 to 180.0
struct YawRotationPackage {
    private bool done = true;

    private double origin = 0;
    private double destination = 0;
    private double progress = 0;

    private double internalSpeedMultiplier = 0.0;
    private double diff = 0.0;

    private double yaw = 0.0;

    this(double yaw, double yawDestination, double speedMultiplier) {
            done = false;
            progress = 0.0;
            origin = yaw;
            destination = yawDestination;

            this.yaw = yaw;

            diff = Math.abs(origin) + Math.abs(destination);

            if (diff >= 180.0) {
                // Overshoot it and correct later
                // The signum is a multiplier based on if it's negative or positive (is 1 or -1)
                double signum = Math.signum(destination);
                destination = (Math.abs(destination) + 180.0) * signum;
            }

            internalSpeedMultiplier = speedMultiplier;
    }

    bool isDone() {
        return this.done;
    }

    double interpolate() {
        if (progress >= 1.0) {
            progress = 1.0;
            done = true;
        } else {
            // Goal has not been reached
            // This is the progress of the linear interpolation
            progress += getDelta() * internalSpeedMultiplier;
        }

        yaw = Math.lerp(origin, destination, progress);
        
        // This is the overshoot correction
        this.yawCorrection(yaw);

        // Uncomment this to see live info on yaw
        // writeln("yaw is: ", yaw);

        assert(yaw >= -180.0 && yaw <= 180.0, "you done goofed");

        return yaw;
    }


    // Overflow or underflow the yaw
    private void yawCorrection(ref double yaw) {
        if (yaw < -180.0) {
            yaw += 360.0;
        } else if (yaw > 180.0) {
            yaw -= 360.0;
        }
    }
}

void main() {
    int tests = 0;

    double yaw = 0;

    // This multiplier can be controlled based on how fast you want the object to interpolate
    double speedMultiplier = 3.0;


    YawRotationPackage yawWorker = YawRotationPackage(yaw, (Math.random() * 360.0) - 180.0, speedMultiplier);

    while(tests < 20) {
        calculateDelta();

        yaw = yawWorker.interpolate();     
        
        if (yawWorker.isDone()) {
            writeln("DONE! yaw is: ", yaw);
            yawWorker = YawRotationPackage(yaw, (Math.random() * 360.0) - 180.0, speedMultiplier);
        }
    }
	
}


