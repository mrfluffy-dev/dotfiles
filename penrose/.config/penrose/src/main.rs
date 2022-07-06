#[macro_use]
extern crate penrose;
use std::thread::sleep;
use std::time::Duration;

use penrose::{
    contrib::{
        actions::{update_monitors_via_xrandr},
        extensions::Scratchpad,
    },
    core::{
        config::Config,
        data_types::RelativePosition,
        helpers::index_selectors,
        hooks::Hook,
        layout::{side_stack, Layout, LayoutConf},
        manager::WindowManager,
        xconnection::XConn,
    },
    logging_error_handler, spawn,
    xcb::{XcbConnection, XcbHooks},
    Backward, Forward, Less, More, Result, Selector,
};

use simplelog::{LevelFilter, SimpleLogger};

// Replace these with your preferred terminal and program launcher
const TERMINAL: &str = "alacritty";

struct StartupHook {}
impl<X: XConn> Hook<X> for StartupHook {
    fn startup(&mut self, wm: &mut WindowManager<X>) -> Result<()> {
        if wm.n_screens() == 1 {
            spawn!("polybar --reload barbase2")
        } else {
            spawn!("polybar --reload barbase1");
            spawn!("polybar --reload barbase2")
        };
        spawn!("xss-lock /home/$USER/.config/scripts/betterlockscreen.sh");
        spawn!("picom --backend glx");
        spawn!("nitrogen --restore");
        spawn!("sxhkd")
    }
}

struct Monitors {}
impl<X> Hook<X> for Monitors
where
    X: XConn,
{
    fn randr_notify(&mut self, wm: &mut WindowManager<X>) -> Result<()> {
        update_monitors_via_xrandr("HDMI-A-0", "eDP", RelativePosition::Left);
        if wm.n_screens() != 1 {
            spawn!("killall polybar");
            let three_seconds = Duration::from_secs(1);
            sleep(three_seconds);
            spawn!("polybar --reload barbase1");
            spawn!("polybar --reload barbase2")
        } else {
            spawn!("echo 'Only one screen connected'")
        }
    }
}

fn main() -> penrose::Result<()> {
    // Initialise the logger (use LevelFilter::Debug to enable debug logging)
    if let Err(e) = SimpleLogger::init(LevelFilter::Info, simplelog::Config::default()) {
        panic!("unable to set log level: {}", e);
    };

    let sp = Scratchpad::new(TERMINAL, 0.8, 0.8);

    let hooks: XcbHooks = vec![
        Box::new(StartupHook {}),
        Box::new(Monitors {}),
        sp.get_hook(),
    ];

    // Created at startup. See keybindings below for how to access them
    let mut config_builder = Config::default().builder();
    config_builder
        .workspaces(vec!["1", "2", "3", "4", "5", "6", "7", "8", "9"])
        // Windows with a matching WM_CLASS will always float
        .floating_classes(vec!["polybar"])
        // Client border colors are set based on X focus
        .focused_border("#8218c4")?
        .unfocused_border("#1A1A1A")?
        .gap_px(5)
        .top_bar(true)
        .bar_height(32);

    // Default number of clients in the main layout area
    let n_main = 1;

    // Default percentage of the screen to fill with the main area of the layout
    let ratio = 0.5;

    config_builder.layouts(vec![
        Layout::new(
        "[side]",
        LayoutConf::default(),
        side_stack,
        n_main,
        ratio,),
    ]);
    let config = config_builder.build().unwrap();
    let key_bindings = gen_keybindings! {
        // Exit Penrose (important to remember this one!)
        "A-S-q" => run_internal!(exit);

        // client management
        "A-j" => run_internal!(cycle_client, Forward);
        "A-k" => run_internal!(cycle_client, Backward);
        "A-S-j" => run_internal!(drag_client, Forward);
        "A-S-k" => run_internal!(drag_client, Backward);
        "A-S-t" => run_internal!(toggle_client_fullscreen, &Selector::Focused);
        "A-q" => run_internal!(kill_client);

        // workspace management
        "A-Tab" => run_internal!(toggle_workspace);
        "A-M-period" => run_internal!(cycle_workspace, Forward);
        "A-M-comma" => run_internal!(cycle_workspace, Backward);

        // move cursor between screens
        "A-l" => run_internal!(cycle_screen, Forward);
        "A-h" => run_internal!(cycle_screen, Backward);

        // Layout management
        "A-grave" => run_internal!(cycle_layout, Forward);
        "A-S-grave" => run_internal!(cycle_layout, Backward);
        "M-A-Up" => run_internal!(update_max_main, More);
        "M-A-Down" => run_internal!(update_max_main, Less);
        "A-S-h" => run_internal!(update_main_ratio, More);
        "A-S-l" => run_internal!(update_main_ratio, Less);

        "A-backslash" => sp.toggle();

        map: { "1", "2", "3", "4", "5", "6", "7", "8", "9" } to index_selectors(9) => {
            "A-{}" => focus_workspace (REF);
            "A-S-{}" => client_to_workspace (REF);
        };
    };
    let conn = XcbConnection::new()?;

    let mut wm = WindowManager::new(config, conn, hooks, logging_error_handler());
    wm.init()?;
    wm.grab_keys_and_run(key_bindings, map! {})
}
