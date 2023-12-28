import { batch, Denops, ensure, is, vars } from "./deps.ts";
import { Dda } from "./dda.ts";

export async function main(denops: Denops) {
  denops.dispatcher = {
    async completion(
      arg1: unknown,
      arg2: unknown,
      arg3: unknown,
    ): Promise<void> {
      const prompt = ensure(arg1, is.String);
      const suffix = ensure(arg2, is.String);
      const userOptions = ensure(arg3, is.Record);

      const dda = new Dda();

      await dda.completion(denops, userOptions, prompt, suffix);
    },
    async edit(arg1: unknown, arg2: unknown, arg3: unknown): Promise<void> {
      const input = ensure(arg1, is.String);
      const instruction = ensure(arg2, is.String);
      const userOptions = ensure(arg3, is.Record);

      const dda = new Dda();

      await dda.edit(denops, userOptions, input, instruction);
    },
  };

  await batch(denops, async (denops: Denops) => {
    await vars.g.set(denops, "dda#_initialized", 1);
    await denops.cmd("doautocmd <nomodeline> User DDAReady");
    await denops.cmd("autocmd! User DDAReady");
  });
}
