import random

def generate_ip():
    """
    Generates a random IP address.

    Returns:
        str: A string representing a random IP address in the format "x.x.x.x".
    """
    return f"{random.randint(1, 255)}.{random.randint(1, 255)}.{random.randint(1, 255)}.{random.randint(1, 255)}"

def generate_access_log_line():
    """
    Generate a log line for an access log.

    Returns:
        str: The generated log line.

    Raises:
        None
    """
    src_ip = generate_ip()
    dest_ip = "192.168.10.10" if random.randint(0, 1) == 0 else "192.168.10.11"
    http_code = random.choices([500] * 15 + list(range(200, 500)), k=1)[0]
    http_path = random.choice(["/post?id=404", "/healthz", "/likes?post=404", "/post/new"])
    resp_bytes = random.randint(1, 200)
    return f"{src_ip};{dest_ip};{http_code};{http_path};{resp_bytes}\n"

with open("access.log", "w") as file:
    file.write("# SRC IP ; DEST IP ; HTTP CODE ; HTTP PATH ; RESP BYTES\n")
    for _ in range(500):
        file.write(generate_access_log_line())
