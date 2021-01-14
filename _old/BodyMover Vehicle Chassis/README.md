# BodyMover Vehicle Chassis by g_captain
Asset: https://www.roblox.com/library/5756450679/BodyMover-Chassis

An vehicle chassis that relies on calculated BodyMovers. This is especially great for vehicles that need more control/reliability and do not depend on wheel physics, such as ferries/boats, heavy-duty vehicles, and even hovercraft. 
This chassis is open-sourced. Feel free to modify it to your choice, and please leave credits to my original code!

### FEATURES:
- Adjustable throttle and steer dampening
- Calculated BodyMovers with LookVector
- Is rarely affected by regular physics (mass, forces)
- Comes with a flip/stabilize key (press G)
- Simulated gravity with raycasting

### CONFIGURATIONS:
- MaxSpeed: The maximum forward/backward velocity.
- MaxSteerVelocity: The velocity that the vehicle will turn.
- ThrottleDifferential: How fast the vehicle will accelerate / the throttle multiple until the vehicle reaches maximum velocity.
- SteerDifferential: How fast the steering will reach maximum steer.

In MainScript:
- gravity: In studs/second - the downward velocity applied when the vehicle is above ground. 
- gravityLeeway: In studs - Added to the Y height where the vehicle is considered on the ground, and "gravity" will not be applied.
