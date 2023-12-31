import React from "react";
import Auth from "../components/auth";
import { GetServerSidePropsContext } from "next";
import nookies from "nookies";
import { userIsLoggedIn } from "../firebase/auth/utils";
import LogoSvg from "../images/svg/logo.svg";
import { ChatBubbleBottomCenterTextIcon } from "@heroicons/react/24/solid";

export default function Login() {
  return (
    <>
      <div className="relative flex min-h-screen flex-col justify-center text-center overflow-hidden bg-gray-100 py-6 sm:py-6">
        <div className="flex justify-center text-crunchy-orange no-underline hover:no-underline font-bold text-2xl lg:text-4xl pb-5">
        <ChatBubbleBottomCenterTextIcon className="text-crunchy-orange w-11 h-11"/>
          <div className="pl-2">Narrator</div>
        </div>
        <Auth />
      </div>
    </>
  );
}

export async function getServerSideProps(ctx: GetServerSidePropsContext) {
  const cookies = nookies.get(ctx);
  const authenticated = await userIsLoggedIn(cookies);

  if (authenticated) {
    ctx.res.writeHead(302, { Location: "/" });
    ctx.res.end();
  }

  return {
    props: {},
  };
}
