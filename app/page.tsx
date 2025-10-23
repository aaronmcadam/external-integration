import { ProductCard } from "@workspace/products-frontend/components/product-card";
import {
  Card,
  CardHeader,
  CardTitle,
  CardDescription,
  CardAction,
  CardContent,
  CardFooter,
} from "@workspace/ui/components/card";
import Image from "next/image";

export default function Home() {
  return (
    <div className="flex min-h-screen items-center justify-center bg-zinc-50 font-sans dark:bg-black">
      <main className="flex w-full max-w-3xl flex-col gap-8 py-16 px-8 sm:px-16">
        <Image
          className="dark:invert"
          src="/next.svg"
          alt="Next.js logo"
          width={100}
          height={20}
          priority
        />
        
        <section>
          <h2 className="text-2xl font-bold mb-4">Generic Cards (from @workspace/ui)</h2>
          <div className="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-3">
            <Card>
              <CardHeader>
                <CardTitle>First Card</CardTitle>
                <CardDescription>Card Description</CardDescription>
                <CardAction>Action</CardAction>
              </CardHeader>
              <CardContent>
                <p>Card Content</p>
              </CardContent>
              <CardFooter>
                <p>Card Footer</p>
              </CardFooter>
            </Card>
            <Card>
              <CardHeader>
                <CardTitle>Second Card</CardTitle>
                <CardDescription>Another description</CardDescription>
                <CardAction>Action</CardAction>
              </CardHeader>
              <CardContent>
                <p>More content here</p>
              </CardContent>
              <CardFooter>
                <p>Footer text</p>
              </CardFooter>
            </Card>
            <Card>
              <CardHeader>
                <CardTitle>Third Card</CardTitle>
                <CardDescription>Yet another card</CardDescription>
                <CardAction>Do it</CardAction>
              </CardHeader>
              <CardContent>
                <p>Even more content</p>
              </CardContent>
              <CardFooter>
                <p>Final footer</p>
              </CardFooter>
            </Card>
          </div>
        </section>

        <section>
          <h2 className="text-2xl font-bold mb-4">Product Cards (from @workspace/products-frontend)</h2>
          <div className="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-3">
            <ProductCard
              name="Wireless Headphones"
              price={9999}
              inStock={true}
              slug="wireless-headphones"
            />
            <ProductCard
              name="Smart Watch"
              price={24999}
              inStock={true}
              slug="smart-watch"
            />
            <ProductCard
              name="Laptop Stand"
              price={4999}
              inStock={false}
              slug="laptop-stand"
            />
          </div>
        </section>
        <div className="flex flex-col gap-4 text-base font-medium sm:flex-row">
          <a
            className="flex h-12 w-full items-center justify-center gap-2 rounded-full bg-foreground px-5 text-background transition-colors hover:bg-[#383838] dark:hover:bg-[#ccc] sm:w-auto"
            href="https://vercel.com/new?utm_source=create-next-app&utm_medium=appdir-template-tw&utm_campaign=create-next-app"
            target="_blank"
            rel="noopener noreferrer"
          >
            <Image
              className="dark:invert"
              src="/vercel.svg"
              alt="Vercel logomark"
              width={16}
              height={16}
            />
            Deploy Now
          </a>
          <a
            className="flex h-12 w-full items-center justify-center rounded-full border border-solid border-black/[.08] px-5 transition-colors hover:border-transparent hover:bg-black/[.04] dark:border-white/[.145] dark:hover:bg-[#1a1a1a] sm:w-auto"
            href="https://nextjs.org/docs?utm_source=create-next-app&utm_medium=appdir-template-tw&utm_campaign=create-next-app"
            target="_blank"
            rel="noopener noreferrer"
          >
            Documentation
          </a>
        </div>
      </main>
    </div>
  );
}
