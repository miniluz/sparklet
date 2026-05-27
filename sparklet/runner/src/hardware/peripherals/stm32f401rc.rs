use embassy_stm32::timer::qei::Qei;
use static_cell::StaticCell;

use crate::hardware::abstractions::{ActiveLow, Button, InputWithPolarity, QeiExt};
use embassy_stm32::peripherals::{TIM2, TIM3, TIM4};

pub struct ConfigHardware {
    pub button_next_page: &'static dyn Button,
    pub button_prev_page: &'static dyn Button,
    pub encoder0: &'static dyn QeiExt,
    pub encoder1: &'static dyn QeiExt,
    pub encoder2: &'static dyn QeiExt,
}

pub static BUTTON_NEXT_PAGE: StaticCell<InputWithPolarity<ActiveLow>> = StaticCell::new();
pub static BUTTON_PREV_PAGE: StaticCell<InputWithPolarity<ActiveLow>> = StaticCell::new();
pub static ENCODER0_QEI: StaticCell<Qei<TIM2>> = StaticCell::new();
pub static ENCODER1_QEI: StaticCell<Qei<TIM3>> = StaticCell::new();
pub static ENCODER2_QEI: StaticCell<Qei<TIM4>> = StaticCell::new();

#[macro_export]
macro_rules! get_config_hardware {
    ($peripherals:ident) => {{
        use embassy_stm32::{
            gpio::{Input, Pull},
            timer::qei::{Qei, QeiPin},
        };
        use $crate::hardware::abstractions::{ActiveLow, InputWithPolarity};
        use $crate::hardware::peripherals::{
            BUTTON_NEXT_PAGE, BUTTON_PREV_PAGE, ConfigHardware, ENCODER0_QEI, ENCODER1_QEI,
            ENCODER2_QEI,
        };

        ConfigHardware {
            button_next_page: BUTTON_NEXT_PAGE.init(InputWithPolarity::<ActiveLow>::new(
                // ALL BUTTONS ARE SPECIFIED WITH THE USB UP
                // Right, second from the bottom
                Input::new($peripherals.PC14, Pull::Up),
            )),
            button_prev_page: BUTTON_PREV_PAGE.init(InputWithPolarity::<ActiveLow>::new(
                // Right, first from the bottom
                Input::new($peripherals.PC15, Pull::Up),
            )),
            encoder0: ENCODER0_QEI.init(Qei::new(
                $peripherals.TIM2,
                // Left, 11th and 12th from the bottom
                QeiPin::new($peripherals.PA15),
                QeiPin::new($peripherals.PB3),
            )),
            encoder1: ENCODER1_QEI.init(Qei::new(
                $peripherals.TIM3,
                // Left, 9th and 10th from the bottom
                QeiPin::new($peripherals.PB4),
                QeiPin::new($peripherals.PB5),
            )),
            encoder2: ENCODER2_QEI.init(Qei::new(
                $peripherals.TIM4,
                // Left, 7th and 8th from the bottom
                QeiPin::new($peripherals.PB6),
                QeiPin::new($peripherals.PB7),
            )),
        }
    }};
}
