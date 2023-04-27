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

    //console.log(completion.choices);
    if (completion.choices.length > 0) {
      const currentText = await denops.call("dda#util#get_input") as string;
      const texts = (currentText + completion.choices[0].text).split("\n");
      await fn.setline(
        denops,
        await fn.line(denops, "."),
        texts,
      );

      const offsetRow = texts.length - 1;
      const offsetCol = await fn.strlen(
        denops,
        texts[texts.length - 1],
      ) as number;
      await fn.cursor(
        denops,
        await fn.line(denops, ".") + offsetRow,
        await fn.col(denops, ".") + offsetCol,
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

    //console.log(edit);
    if (edit.choices.length > 0) {
      await fn.setline(
        denops,
        await fn.line(denops, "."),
        edit.choices[0].text.split("\n"),
      );
    }
  }
}
