use stm32f1xx_hal::gpio::{Output, PinState};
use core::cell::RefCell;
use stm32f1xx_hal::{pac, prelude::*};
use stm32f1xx_hal::gpio::{Edge, ExtiPin, Pin};

fn get_option(num:u32) -> &'static str {
    let mapping:[(u32,&str);10] = [
        (0,"0111111" ),
        (1,"0001001" ),
        (2,"1011110" ),
        (3,"1011011" ),
        (4,"1101001" ),
        (5,"1110011" ),
        (6,"1110111" ),
        (7,"0011001" ),
        (8,"1111111" ),
        (9,"1111011" ),
    ];
    let option_num = num % 10;

    for (k,v) in mapping {
        if k == option_num {
            return v;
        }
    }
    mapping[0].1
}

enum PinA {
    Pin0(RefCell<Pin<'A', 0,Output>>),
    Pin1(RefCell<Pin<'A', 1,Output>>),
    Pin2(RefCell<Pin<'A', 2,Output>>),
    Pin3(RefCell<Pin<'A', 3,Output>>),
    Pin4(RefCell<Pin<'A', 4,Output>>),
    Pin5(RefCell<Pin<'A', 5,Output>>),
    Pin6(RefCell<Pin<'A', 6,Output>>),
}

impl PinA {
    fn switch_of (&self,sw:bool) {
        let action = if sw {
            PinState::High
        }else {
            PinState::Low
        };
        match self {
            PinA::Pin0(ref e) => { e.borrow_mut().set_state(action) }
            PinA::Pin1(ref e) => { e.borrow_mut().set_state(action) }
            PinA::Pin2(ref e) => { e.borrow_mut().set_state(action) }
            PinA::Pin3(ref e) => { e.borrow_mut().set_state(action) }
            PinA::Pin4(ref e) => { e.borrow_mut().set_state(action) }
            PinA::Pin5(ref e) => { e.borrow_mut().set_state(action) }
            PinA::Pin6(ref e) => { e.borrow_mut().set_state(action) }
        };
    }
}

fn open_line(pins : &[PinA;7], nums: u32) {
    
    let operation = get_option(nums);

    // 遍历操作码并设置每个引脚状态
    for (i, pin) in operation.chars().enumerate() {
        pins[i].switch_of(pin=='1');
    }
}


pub fn start() -> !{
    
    let cp = cortex_m::Peripherals::take().unwrap();
    let dp = pac::Peripherals::take().unwrap();

    let mut gpioa = dp.GPIOA.split();
    let mut gpiob = dp.GPIOB.split();
    let mut afio = dp.AFIO.constrain();
    // let mut gpioc = dp.GPIOC.split();
    // 
    // let mut pc13 = gpioc.pc13.into_push_pull_output(&mut gpioc.crh);
    
    let mut pb1 = gpiob.pb1.into_pull_up_input(&mut gpiob.crl);
    
    let mut flash = dp.FLASH.constrain();

    let rcc = dp.RCC.constrain();
    let clocks = rcc.cfgr.freeze(&mut flash.acr);
    let mut delay = cp.SYST.delay(&clocks);
    
    let mut num = 0u32;

    let mut h = gpioa.pa7.into_push_pull_output(&mut gpioa.crl); // h
    h.set_low(); // 初始化 h

    let g = gpioa.pa0.into_push_pull_output(&mut gpioa.crl); // g
    let f = gpioa.pa1.into_push_pull_output(&mut gpioa.crl); // f
    let a = gpioa.pa2.into_push_pull_output(&mut gpioa.crl); // a
    let b = gpioa.pa3.into_push_pull_output(&mut gpioa.crl); // b
    let e = gpioa.pa4.into_push_pull_output(&mut gpioa.crl); // e
    let d = gpioa.pa5.into_push_pull_output(&mut gpioa.crl); // d
    let c = gpioa.pa6.into_push_pull_output(&mut gpioa.crl); // c

    let pins = [
        PinA::Pin0(RefCell::from(g)),
        PinA::Pin1(RefCell::from(f)),
        PinA::Pin2(RefCell::from(a)),
        PinA::Pin3(RefCell::from(b)),
        PinA::Pin4(RefCell::from(e)),
        PinA::Pin5(RefCell::from(d)),
        PinA::Pin6(RefCell::from(c)),
    ];

    open_line(&pins,num.clone());

    let mut exti = dp.EXTI;

    pb1.make_interrupt_source(&mut afio);
    pb1.enable_interrupt(&mut exti);
    pb1.trigger_on_edge(&mut exti,Edge::Falling);

    loop {
        // your code goes here

        if pb1.check_interrupt(){
            
            num += 1;
            open_line(&pins,num.clone());

            delay.delay_ms(200_u16);
            
            pb1.clear_interrupt_pending_bit();
        }
        
    }
} 
