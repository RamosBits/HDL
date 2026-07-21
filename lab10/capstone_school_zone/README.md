# Smart School-Zone Traffic Controller

## Project Summary

This capstone extends the basic Lab 10 traffic-light controller into a smart school-zone intersection controller. The design controls a main road and a side road using a finite state machine with timed state transitions, reset behavior, pedestrian request handling, and a school-zone mode.

The original idea added here is a safer school crossing mode. When `school_zone` is active, the side-road green and pedestrian walk interval lasts longer so students have more time to cross. The controller also includes all-red buffer states before switching right-of-way, which prevents unsafe instant transitions between roads.

## State Order

| State | Main Road | Side Road | Walk Light | Purpose |
| --- | --- | --- | --- | --- |
| `MAIN_GREEN` | Green | Red | Off | Default traffic flow after reset |
| `MAIN_YELLOW` | Yellow | Red | Off | Warning before main road stops |
| `ALL_RED_TO_SIDE` | Red | Red | Off | Safety buffer before side road goes |
| `SIDE_GREEN` | Red | Green | On | Side road and pedestrian crossing |
| `SIDE_YELLOW` | Red | Yellow | Off | Warning before side road stops |
| `ALL_RED_TO_MAIN` | Red | Red | Off | Safety buffer before main road goes |

## Timing Behavior

- Normal Main Green lasts `8` clock ticks.
- If `ped_request` is active during Main Green, Main Green is shortened to `3` clock ticks.
- Yellow states last `2` clock ticks.
- All-red safety buffer states last `1` clock tick.
- Normal Side Green lasts `4` clock ticks.
- In school-zone mode, Side Green lasts `7` clock ticks.

## Safety Behavior

The main road and side road are never green at the same time. Before the right-of-way changes, the controller always passes through a yellow state and then an all-red buffer state. This makes the design safer than a direct green-to-green transition.

## Pedestrian Request Behavior

The `ped_request` input is latched as `ped_pending`. If a request arrives, the controller remembers it until the side-road crossing interval is served. During Main Green, the request shortens the timer so the controller moves to Main Yellow earlier than normal.

## School-Zone Behavior

The `school_zone` input turns on `school_warning` and extends the Side Green interval. Since `walk_light` is on only during Side Green, students get a longer crossing time during school-zone mode.

## Simulation Evidence

The testbench covers:

- Reset behavior
- Normal traffic-light cycling
- Pedestrian request during operation
- School-zone mode
- An edge case where a pedestrian request happens while the side road is already being served
- Safety checking with a printed `safe` column

## Waveform Order

Use this signal order in VaporView, Surfer, or GTKWave:

```text
tb_school_zone_controller.clk
tb_school_zone_controller.reset
tb_school_zone_controller.ped_request
tb_school_zone_controller.school_zone
tb_school_zone_controller.state_dbg[2:0]
tb_school_zone_controller.timer_dbg[3:0]
tb_school_zone_controller.main_light[2:0]
tb_school_zone_controller.side_light[2:0]
tb_school_zone_controller.walk_light
tb_school_zone_controller.school_warning
```

## Presentation Note

My capstone is a smart school-zone traffic-light controller. It uses an FSM to safely move through Main Green, Main Yellow, All Red, Side Green, Side Yellow, and All Red before returning to Main Green. The design improves the base lab by adding a school-zone mode, a pedestrian walk light, a latched pedestrian request, and all-red safety buffers. The pedestrian request shortens the Main Green interval, while school-zone mode extends the Side Green and walk-light interval for safer student crossing. The waveform and terminal output prove that reset works, the state order is safe, and the main road and side road are never green at the same time.
