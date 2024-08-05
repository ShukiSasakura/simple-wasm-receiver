use clap::Parser;
use std::io::{Read, Write};
use std::net::TcpStream;

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args{
    #[arg(short, long, default_value_t = String::from("127.0.0.1:8000"))]
    distination_address: String,

    #[arg(short, long, default_value_t = 100000)]
    msg_num: usize,
}

fn main() -> std::io::Result<()>{
    let args = Args::parse();

    let distination_address = args.distination_address;
    let msg_num = args.msg_num;

    let mut stream = match TcpStream::connect(distination_address) {
        Ok(stream) => stream,
        Err(e) => return Err(e)
    };

    let mut msg: [u8; 1024] = [1; 1024];
    let mut ack: [u8; 1024] = [0; 1024];

    for i in 1..=msg_num {
        if i == msg_num {
            msg[0] = 2;
        }
        // send msg
        let _ = stream.write_all(& msg);

        // receive ack
        let _ = stream.read_exact(&mut ack);
    }

    stream.flush().unwrap();

    Ok(())
}
