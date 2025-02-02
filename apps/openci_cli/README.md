# OpenCI CLI

A command line interface for interacting with Apple's App Store Connect API to manage certificates, provisioning profiles, and more.

## Features

- 🍎 App Store Connect integration
- 🔐 Certificate management
- 📱 Provisioning profile operations
- 🚀 Beta build submission
- 🔄 Clean API client implementation

## Requirements

- Dart SDK version 3.5.0 or higher.
- A valid App Store Connect account with API credentials.
- macOS (e.g. M1 Max on macOS Sequoia) is recommended for development.

## Installation

Install via Dart pub:

```bash
dart pub global activate openci_cli2
```

Make sure your Dart pub global bin directory is in your PATH.


## Usage

Display help:

```bash
openci_cli2 --help
```

The CLI supports various commands, which are grouped as follows:

### Certificate Commands

- **Create Certificate**

  Create a new certificate using your credentials.
  
  ```bash
  openci_cli2 create-certificate \
    --issuer-id YOUR_ISSUER_ID \
    --key-id YOUR_KEY_ID \
    --path-to-private-key /path/to/AuthKey.p8 \
    --certificate-type DISTRIBUTION
  ```

- **List Certificates**

  List available certificates.
  
  ```bash
  openci_cli2 list-certificates \
    --issuer-id YOUR_ISSUER_ID \
    --key-id YOUR_KEY_ID \
    --path-to-private-key /path/to/AuthKey.p8
  ```

- **Read Certificate**

  Retrieve details of a specific certificate.
  
  ```bash
  openci_cli2 read-certificate \
    --issuer-id YOUR_ISSUER_ID \
    --key-id YOUR_KEY_ID \
    --path-to-private-key /path/to/AuthKey.p8 \
    --certificate-id CERTIFICATE_ID
  ```

### Provisioning Profile Commands

- **Create Provisioning Profile**

  Create a new provisioning profile.
  
  ```bash
  openci_cli2 create-provisioning-profile \
    --issuer-id YOUR_ISSUER_ID \
    --key-id YOUR_KEY_ID \
    --path-to-private-key /path/to/AuthKey.p8 \
    --profile-id PROFILE_ID
  ```

- **List Provisioning Profiles**

  List available provisioning profiles.
  
  ```bash
  openci_cli2 list-provisioning-profile \
    --issuer-id YOUR_ISSUER_ID \
    --key-id YOUR_KEY_ID \
    --path-to-private-key /path/to/AuthKey.p8
  ```

- **Delete Provisioning Profile**

  Delete an existing provisioning profile.
  
  ```bash
  openci_cli2 delete-provisioning-profile \
    --issuer-id YOUR_ISSUER_ID \
    --key-id YOUR_KEY_ID \
    --path-to-private-key /path/to/AuthKey.p8 \
    --profile-id PROFILE_ID
  ```

### Bundle ID Commands

- **List Bundle IDs**

  Retrieve a list of bundle identifiers.
  
  ```bash
  openci_cli2 list-bundle-ids \
    --issuer-id YOUR_ISSUER_ID \
    --key-id YOUR_KEY_ID \
    --path-to-private-key /path/to/AuthKey.p8 \
    --filter-identifier io.example.app
  ```

## Configuration

Before using the CLI, ensure you have the following:

- Your App Store Connect API credentials (Issuer ID, Key ID, and Private Key).
- An accessible private key file (AuthKey.p8) on your system.

## License

This project is licensed under the Apache License, Version 2.0. See the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please fork the repository and submit pull requests for any improvements or bug fixes.

## Additional Information

For detailed documentation and advanced usage, please refer to the official documentation or the source code comments.


