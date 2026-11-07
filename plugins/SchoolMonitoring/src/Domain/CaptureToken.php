<?php
declare(strict_types=1);

namespace SchoolMonitoring\Domain;

final class CaptureToken
{
    public function __construct(private string $secret)
    {
    }

    public function issue(int $userId, string $lessonKey, int $phase, int $ttlSeconds = 120): string
    {
        $exp = time() + $ttlSeconds;
        $nonce = bin2hex(random_bytes(16));
        $payload = $userId . '|' . $lessonKey . '|' . $phase . '|' . $exp . '|' . $nonce;

        return rtrim(strtr(base64_encode($payload), '+/', '-_'), '=') . '.' . hash_hmac('sha256', $payload, $this->secret);
    }

    /**
     * @return array{user_id: int, lesson_key: string, phase: int, exp: int, nonce: string}
     */
    public function verify(string $token, int $userId, string $lessonKey, int $phase): array
    {
        $parts = explode('.', $token, 2);
        if (count($parts) !== 2) {
            throw new \RuntimeException('invalid_token');
        }
        [$encoded, $mac] = $parts;
        $payload = base64_decode(strtr($encoded, '-_', '+/'), true);
        if ($payload === false || !hash_equals(hash_hmac('sha256', $payload, $this->secret), $mac)) {
            throw new \RuntimeException('invalid_token');
        }
        [$uid, $key, $ph, $exp, $nonce] = array_pad(explode('|', $payload, 5), 5, '');
        if ((int)$uid !== $userId || $key !== $lessonKey || (int)$ph !== $phase) {
            throw new \RuntimeException('token_mismatch');
        }
        if (time() > (int)$exp) {
            throw new \RuntimeException('token_expired');
        }

        return [
            'user_id' => (int)$uid,
            'lesson_key' => $key,
            'phase' => (int)$ph,
            'exp' => (int)$exp,
            'nonce' => $nonce,
        ];
    }
}
