use defmt::info;
use usb::USB_MODE;

#[cfg(feature = "configurable")]
pub mod abstractions;
#[cfg(feature = "audio-usb")]
pub mod audio_usb;
#[cfg(feature = "configurable")]
pub mod config;
#[cfg(feature = "midi-din")]
pub mod midi_din;
#[cfg(feature = "midi-usb")]
pub mod midi_usb;
#[cfg(feature = "usb")]
pub mod usb;

pub struct Hardware {
    #[cfg(feature = "midi-din")]
    pub midi_hardware: midi_din::MidiDinHardware<'static>,
    #[cfg(feature = "midi-usb")]
    pub midi_hardware: midi_usb::MidiUsbHardware<'static>,
    #[cfg(feature = "usb")]
    pub usb_builder: embassy_usb::Builder<'static, embassy_stm32::usb::Driver<'static, USB_MODE>>,
    #[cfg(feature = "audio-usb")]
    pub audio_hardware: audio_usb::AudioUsbHardware<'static>,
    #[cfg(feature = "configurable")]
    pub config_hardware: config::ConfigHardware,
}

impl Hardware {
    pub fn get() -> Hardware {
        info!("Initializing");

        let mut config = embassy_stm32::Config::default();
        #[cfg(feature = "usb")]
        {
            info!("USB config being added...");
            crate::configure_usb!(config);
            info!("USB config added.")
        }

        let peripherals = embassy_stm32::init(config);

        #[cfg(feature = "usb")]
        let mut usb_builder = {
            let usb_hardware = crate::get_usb_hardware!(peripherals);

            let mut usb_config = embassy_usb::Config::new(0xc0de, 0xcafe);

            usb_config.manufacturer = Some("miniluz");
            usb_config.product = Some("Sparklet Synth");
            usb_config.serial_number = Some("12345678");

            embassy_usb::Builder::new(
                usb_hardware.driver,
                usb_config,
                usb_hardware.config_descriptor,
                usb_hardware.bos_descriptor,
                &mut [],
                usb_hardware.control_buf,
            )
        };

        #[cfg(feature = "midi-din")]
        let midi_hardware = crate::get_midi_din_hardware!(peripherals);

        #[cfg(feature = "midi-usb")]
        let midi_hardware = crate::get_midi_usb_hardware!(&mut usb_builder);

        #[cfg(feature = "audio-usb")]
        let audio_hardware = crate::get_audio_usb_hardware!(&mut usb_builder);

        #[cfg(feature = "configurable")]
        let config_hardware = crate::get_config_hardware!(peripherals);

        Hardware {
            #[cfg(feature = "midi-din")]
            midi_hardware,
            #[cfg(feature = "midi-usb")]
            midi_hardware,
            #[cfg(feature = "usb")]
            usb_builder,
            #[cfg(feature = "audio-usb")]
            audio_hardware,
            #[cfg(feature = "configurable")]
            config_hardware,
        }
    }
}
