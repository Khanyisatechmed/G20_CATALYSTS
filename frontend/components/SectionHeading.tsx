type SectionHeadingProps = {
  eyebrow: string;
  title: string;
  description?: string;
};

export default function SectionHeading({
  eyebrow,
  title,
  description
}: SectionHeadingProps) {
  return (
    <div>
      <p className="text-sm font-black uppercase tracking-[0.28em] text-brand-terracotta">
        {eyebrow}
      </p>
      <h1 className="mt-4 max-w-4xl font-serif text-5xl font-black leading-tight text-brand-deep">
        {title}
      </h1>
      {description ? (
        <p className="mt-5 max-w-3xl text-lg leading-8 text-brand-deep/75">
          {description}
        </p>
      ) : null}
    </div>
  );
}
