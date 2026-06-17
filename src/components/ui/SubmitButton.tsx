"use client";

import { useFormStatus } from "react-dom";

export function SubmitButton({
  children,
  variant = "primary",
}: {
  children: React.ReactNode;
  variant?: "primary" | "danger";
}) {
  const { pending } = useFormStatus();

  const base =
    "inline-flex items-center justify-center rounded-md px-3 py-2 text-sm font-medium transition disabled:opacity-60";
  const styles =
    variant === "danger"
      ? "border border-red-300 text-red-700 hover:bg-red-50 dark:border-red-800 dark:text-red-300 dark:hover:bg-red-950"
      : "bg-zinc-900 text-white hover:bg-zinc-700 dark:bg-zinc-50 dark:text-zinc-900 dark:hover:bg-zinc-200";

  return (
    <button type="submit" disabled={pending} className={`${base} ${styles}`}>
      {pending ? "Working…" : children}
    </button>
  );
}
