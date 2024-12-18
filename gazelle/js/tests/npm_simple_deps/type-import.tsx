import { describe, vi } from "vitest";

describe("a test", () => {
    vi.mock("@aspect-test/b", async importActual => ({
        ...importActual<typeof import("@aspect-test/b")>(),
    }));
});
