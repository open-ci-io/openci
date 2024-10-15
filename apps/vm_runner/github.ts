export async function getGithubAccessToken(
    installationId: number,
    baseUrl: string,
): Promise<string> {
    const url = new URL("/installation_token", baseUrl);
    const body = JSON.stringify({
        installationId: installationId,
    });

    const response = await fetch(url, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: body,
    });

    if (!response.ok) {
        throw new Error(`APIエラー: ${await response.text()}`);
    }

    const responseBody = await response.json();
    return responseBody.installation_token.toString();
}
