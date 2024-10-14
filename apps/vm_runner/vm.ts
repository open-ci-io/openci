import { green, yellow } from "https://deno.land/std@0.224.0/fmt/colors.ts";

export async function cleanUpVMs() {
  while (true) {
    const command = new Deno.Command("tart", { args: ["list"] });
    const output = await command.output();
    const result = new TextDecoder().decode(output.stdout);

    const lines = result.split("\n").slice(1); // ヘッダー行をスキップ
    for (const line of lines) {
      const parts = line.trim().split(/\s+/);
      if (parts.length >= 2) {
        const deletingVmName = parts[1];
        if (deletingVmName !== "sonoma") {
          console.log(`VMを削除中: ${deletingVmName}`);
          const deleteCommand = new Deno.Command("tart", {
            args: ["delete", deletingVmName],
          });
          try {
            await deleteCommand.output();
            console.log(green(`${deletingVmName} を削除しました`));
          } catch (error) {
            console.error(
              yellow(
                `${deletingVmName} の削除中にエラーが発生しました: ${error}`,
              ),
            );
          }
        }
      }
    }

    console.log(green("全てのVMの削除が完了しました"));
    break;
  }
}
