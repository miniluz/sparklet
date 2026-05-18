use embassy_stm32::bind_interrupts;
use embassy_stm32::peripherals;
use embassy_stm32::usb;
use static_cell::StaticCell;

pub use peripherals::USB_OTG_FS as USB_MODE;

bind_interrupts!(pub struct Irqs {
    OTG_FS => usb::InterruptHandler<USB_MODE>;
});

pub struct UsbHardware<'d> {
    pub driver: usb::Driver<'d, USB_MODE>,
    pub config_descriptor: &'d mut [u8; 256],
    pub bos_descriptor: &'d mut [u8; 32],
    pub control_buf: &'d mut [u8; 64],
}

pub static CONFIG_DESCRIPTOR: StaticCell<[u8; 256]> = StaticCell::new();
pub static BOS_DESCRIPTOR: StaticCell<[u8; 32]> = StaticCell::new();
pub static CONTROL_BUF: StaticCell<[u8; 64]> = StaticCell::new();
pub static EP_OUT_BUFFER: StaticCell<[u8; 320]> = StaticCell::new(); // 64 control + 256 max packet

#[macro_export]
macro_rules! get_usb_hardware {
    ($peripherals:ident) => {{
        let config_descriptor = $crate::hardware::usb::CONFIG_DESCRIPTOR.init([0; 256]);
        let bos_descriptor = $crate::hardware::usb::BOS_DESCRIPTOR.init([0; 32]);
        let control_buf = $crate::hardware::usb::CONTROL_BUF.init([0; 64]);
        let ep_out_buffer = $crate::hardware::usb::EP_OUT_BUFFER.init([0u8; 320]);

        // Create the USB driver
        let mut usb_config = embassy_stm32::usb::Config::default();
        usb_config.vbus_detection = false;

        let driver = embassy_stm32::usb::Driver::new_fs(
            $peripherals.USB_OTG_FS,
            $crate::hardware::usb::Irqs,
            $peripherals.PA12,
            $peripherals.PA11,
            ep_out_buffer,
            usb_config,
        );

        $crate::hardware::usb::UsbHardware {
            driver,
            config_descriptor,
            bos_descriptor,
            control_buf,
        }
    }};
}

#[macro_export]
macro_rules! configure_usb {
    ($config:ident) => {{
        use embassy_stm32::rcc::*;
        // Configure clocks for STM32F401RC using internal HSI (16 MHz)
        // 16 / 8 * 168 / 4 = 84 MHz (SYSCLK)
        // 16 / 8 * 168 / 7 = 48 MHz (USB)
        $config.rcc.pll_src = PllSource::HSI;
        $config.rcc.pll = Some(Pll {
            prediv: PllPreDiv::DIV8,
            mul: PllMul::MUL168,
            divp: Some(PllPDiv::DIV4), // 84 MHz
            divq: Some(PllQDiv::DIV7), // 48 MHz
            divr: None,
        });
        $config.rcc.sys = Sysclk::PLL1_P;
        $config.rcc.ahb_pre = AHBPrescaler::DIV1; // 84 MHz
        $config.rcc.apb1_pre = APBPrescaler::DIV2; // 42 MHz
        $config.rcc.apb2_pre = APBPrescaler::DIV1; // 84 MHz
        $config.rcc.mux.clk48sel = mux::Clk48sel::PLL1_Q;
    }};
}

#[cfg(feature = "usb")]
#[embassy_executor::task]
pub async fn usb_device_task(
    mut usb_device: embassy_usb::UsbDevice<'static, embassy_stm32::usb::Driver<'static, USB_MODE>>,
) {
    usb_device.run().await;
}
