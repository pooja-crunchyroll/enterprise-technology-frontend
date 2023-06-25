import React from "react";
import Link from "next/link";
import Image from "next/image";
import hero from "../../images/hero.png";
import { ChatBubbleBottomCenterTextIcon } from "@heroicons/react/24/solid";

export default function Splash() {
  return (
    <>
   
      <div className="h-screen pb-14 flex flex-col bg-white z-50">
        <div className="w-full container mx-auto p-6">
          <div className="w-full flex items-center justify-between">
            <div className="flex items-center text-crunchy-orange no-underline hover:no-underline font-bold text-2xl lg:text-4xl">
              <ChatBubbleBottomCenterTextIcon className="text-crunchy-orange w-11 h-11"/>
              <div className="pl-2">Narrator</div>
            </div>

            <div className="flex w-1/2 justify-end content-center">

              <Link href="/login">
                <a>
                  <button className="bg-crunchy-orange opacity-70 hover:opacity-100 text-white font-bold py-2 px-4 rounded-full">
                    Sign in
                  </button>
                </a>
              </Link>
            </div>
          </div>
        </div>

        <div className="container pt-24 md:pt-12 px-6 mx-auto flex flex-no-wrap flex-col md:flex-row items-center">
          <div className="flex flex-col w-full xl:w-2/5 justify-center lg:items-start overflow-y-hidden">
            <h1 className="my-4 text-5xl md:text-7xl text-crunchy-blue font-bold leading-tight text-center md:text-left slide-in-bottom-h1">
              AI Powered
            </h1>
            <h1 className="my-4 text-4xl md:text-7xl text-orange-600 font-bold leading-tight text-center md:text-left slide-in-bottom-h1">
             Speech to Text
            </h1>
            <p className="leading-normal italic ml-10 text-2xl md:text-2xl mb-8 text-center md:text-left slide-in-bottom-subtitle">
              ... FOR ANIME!
            </p>
          </div>
          <div className="flex-0 items-end  ">
            <Image src="/hime.png" width={500} height={500} layout="intrinsic"/>
            </div>
        </div>
      </div>
      <div className="fixed flex items-center w-full bottom-0 text-gray-500 z-10 bg-white ">
        <div className="mx-auto flex flex-col items-center">
          <span>&copy; 2023 Crunchyroll Enterprise Technology</span>
          <span className="text-sm">Support: EnterpriseTechnologyEngineering@Crunchyroll.com</span>
          </div>
        </div>
    </>
  );
}
