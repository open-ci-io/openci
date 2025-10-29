use hmac::{Hmac, Mac};
use sha2::Sha256;

type HmacSha256 = Hmac<Sha256>;

pub fn verify_hmac_signature(signature: &[u8], secret: String, body: &[u8]) -> bool {
    let mut mac = match HmacSha256::new_from_slice(secret.as_bytes()) {
        Ok(mac) => mac,
        Err(_) => return false,
    };

    mac.update(body);

    mac.verify_slice(signature).is_ok()
}

#[cfg(test)]
mod tests {
    use super::*;
    use hmac::Mac;

    #[test]
    fn verify_signature_accepts_matching_payload() {
        let secret = "demo_secret".to_string();
        let payload = br#"{"hello":"world"}"#;

        let mut mac = HmacSha256::new_from_slice(secret.as_bytes()).unwrap();
        mac.update(payload);
        let signature = mac.finalize().into_bytes();

        assert!(verify_hmac_signature(&signature, secret.clone(), payload));
    }

    #[test]
    fn verify_signature_rejects_tampered_payload() {
        let secret = "demo_secret".to_string();
        let payload = br#"{"hello":"world"}"#;

        let mut mac = HmacSha256::new_from_slice(secret.as_bytes()).unwrap();
        mac.update(payload);
        let signature = mac.finalize().into_bytes();

        let tampered_payload = br#"{"hello":"mars"}"#;
        assert!(!verify_hmac_signature(
            &signature,
            secret.clone(),
            tampered_payload
        ));
    }

    #[test]
    fn verify_signature_rejects_tampered_secret() {
        let secret = "demo_secret".to_string();
        let payload = br#"{"hello":"world"}"#;

        let mut mac = HmacSha256::new_from_slice(secret.as_bytes()).unwrap();
        mac.update(payload);
        let signature = mac.finalize().into_bytes();

        let tampered_secret = "fake_secret".to_string();
        assert!(!verify_hmac_signature(&signature, tampered_secret, payload));
    }
}
