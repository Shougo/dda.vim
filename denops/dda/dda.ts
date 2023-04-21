import { Denops, fn } from "./deps.ts";
import { UserOptions } from "./types.ts";
import { OpenAI } from "https://deno.land/x/openai@1.3.1/mod.ts";
import { Env } from "https://deno.land/x/env@v2.2.3/env.js";

const env = new Env();

export class Dda {
  async completion(
    denops: Denops,
    userOptions: UserOptions,
    prompt: string,
    suffix: string,
  ): Promise<void> {
    const key = env.get("OPENAI_API_KEY", "");

    const openAI = new OpenAI(key);

    const completion = await openAI.createCompletion({
      model: "text-davinci-003",
      prompt,
      suffix,
      maxTokens: 2048,
    });

    console.log(completion.choices);
    if (completion.choices.length > 0) {
      await fn.append(
        denops,
        await fn.line(denops, "."),
        completion.choices[0].text.split("\n"),
      );
    }
  }

  async edit(
    denops: Denops,
    userOptions: UserOptions,
    input: string,
    instruction: string,
  ): Promise<void> {
    const key = env.get("OPENAI_API_KEY", "");

    const openAI = new OpenAI(key);

    const edit = await openAI.createEdit({
      model: "text-davinci-edit-001",
      input,
      instruction,
    });

    console.log(edit);
    if (edit.choices.length > 0) {
      await fn.setline(
        denops,
        await fn.line(denops, "."),
        edit.choices[0].text.split("\n"),
      );
    }
  }
}
