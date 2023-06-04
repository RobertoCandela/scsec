SCSEC

SCSEC (SheerCold Security) is a command-line tool written in Bash that provides file encryption and decryption functionality using AES-256 encryption with a passphrase.

Prerequisites

To use SCSEC, you need to have the following software installed on your system:

- Bash (version 4 or higher)
- OpenSSL

Installation

1. Clone the SCSEC repository:

   git clone https://github.com/RobertoCandela/scsec.git

2. Navigate to the SCSEC directory:

   cd scsec

3. Make the SCSEC script executable:

   chmod +x scsec

4. Optionally, you can move the SCSEC script to a directory in your system's PATH to make it globally accessible:

   sudo mv scsec /usr/local/bin/

Usage

SCSEC can be used for the following operations:

- Encoding a file:
scsec -E <file>

- Decoding an encoded file:
scsec -D <file>

Replace `<file>` with the path to the file you want to encode or decode.

Please note that SCSEC uses AES-256 encryption, and you need to provide a passphrase for encoding and decoding.

Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request on GitHub.

License

This project is licensed under the MIT License. See the LICENSE file for details.
Please note that this is a basic template, and you can customize it according to your specific requirements.