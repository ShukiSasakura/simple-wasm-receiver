use std::io::{Read, Write};
use std::net::{TcpListener, TcpStream};
use std::time::{Duration, Instant};

fn main() -> std::io::Result<()> {
    let listener = TcpListener::bind("127.0.0.1:8000").unwrap();
    let start_time = Instant::now();

    println!("id,time");
    loop {
        let stream = loop {
            if let Ok(stream) = accept(&listener) {
                break stream;
            }
            std::thread::sleep(Duration::from_millis(1));
        };

        std::thread::spawn(move || receive_msg(stream, &start_time));
    }

    // unreachable
}

fn accept(listener: &TcpListener) -> std::io::Result<TcpStream> {
    let (stream, _) = listener.accept()?;
    stream.set_nodelay(true)?;
    Ok(stream)
}

fn receive_msg(mut stream: TcpStream, start_time: &Instant) -> std::io::Result<()> {
    let mut records = Vec::new();

    loop{
        let mut msg: [u8; 1024] = [0; 1024];

        // receive message
        let _ = stream.read_exact(&mut msg);
        let elapsed_time = start_time.elapsed();
        let received_time = elapsed_time.as_nanos() as u64;
        records.push(received_time);

        // send ack
        let ack: [u8; 1024] = msg;
        let _ = stream.write_all(&ack);

        if msg[0] == 2 {
            break
        };
    }

    records.iter()
          .enumerate()
          .for_each(|(num, record)|
                    println!("{},{}", num, record)
                    );

    Ok(())
}
