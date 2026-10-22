<?php

namespace App\Services;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Laravel\Sanctum\PersonalAccessToken;

/**
 * Owns authentication: creating the account, verifying credentials, issuing API
 * tokens and tearing sessions/tokens down. Supports two client shapes at once:
 * browser SPAs (session cookie, established automatically by Sanctum's stateful
 * middleware when the request's Origin is trusted) and native clients, which
 * never get a session and instead receive a bearer token to send on every
 * subsequent request.
 */
class AuthService
{
    /** @param array<string, mixed> $attributes */
    public function register(array $attributes, Request $request): array
    {
        $user = User::create($attributes);

        return $this->establishAuthentication($user, $request);
    }

    /** @return array{user: User, token: string}|null */
    public function attempt(string $email, string $password, Request $request): ?array
    {
        $user = User::query()->where('email', $email)->first();
        if ($user === null || ! Hash::check($password, $user->password)) {
            return null;
        }

        return $this->establishAuthentication($user, $request);
    }

    public function logout(Request $request): void
    {
        $token = $request->user()?->currentAccessToken();
        if ($token instanceof PersonalAccessToken) {
            $token->delete();
        }

        if ($request->hasSession()) {
            Auth::guard('web')->logout();
            $request->session()->invalidate();
            $request->session()->regenerateToken();
        }

        Auth::forgetGuards();
    }

    /** @return array{user: User, token: string} */
    private function establishAuthentication(User $user, Request $request): array
    {
        if ($request->hasSession()) {
            Auth::login($user);
            $request->session()->regenerate();
        }

        $token = $user->createToken('mobile')->plainTextToken;

        return ['user' => $user, 'token' => $token];
    }
}
