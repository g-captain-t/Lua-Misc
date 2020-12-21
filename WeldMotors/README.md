# Weld Motors
A custom motor 'object' alternative to Motor6D, and works only with simple Weld CFraming.
This is meant to be treated like any Roblox object: just place under a part, configure the 
properties and click run.

The motors work with degrees instead of radians for easier configuration. You can also
decide which axis the motor will spin in.

The motors come with two versions: one that uses Values to store properties, and another 
that uses a module.
- To configure the Values: just refer to the Value's ``Value`` property and set it accordingly.
- To configure the Module: if from a script, ``require()`` the module and set the needed properties.

## Properties
``string Axis``: The axis spin of the motor (``"X"``, ``"Y"`` or ``"Z"``). \
``number CurrentAngle``: The current angle of the motor in degrees. \
``number DesiredAngle``: The goal angle in degrees. In the module version, this can be math.huge/infinite. \
``number MaxVelocity``: The velocity of the spin in degrees per second. \
``object Part0``: The pivot part. \
``object Part1``: The moving part. 
