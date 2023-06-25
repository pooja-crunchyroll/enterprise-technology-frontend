import React from "react";
import { Transition } from "@headlessui/react";
import { useState } from "react";
import NavBarOptions from "./NavBarOptions";
import { ArrowLeftOnRectangleIcon, ChatBubbleBottomCenterTextIcon } from '@heroicons/react/24/solid'
import { signOut } from "../../../utils/genericUtils";
export default function NavBar() {
  const [isOpen, setIsOpen] = useState(false);
  return (
    <>
      <nav className="bg-white sticky top-0 z-50 border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16 border-b border-gray-200">
            <div className="flex items-center text-xl font-bold pl-3 no-underline text-crunchy-orange">
              <ChatBubbleBottomCenterTextIcon className="h-6 w-6" />

              <div className="pl-3">Narrator</div>
            </div>
            <div className="-mr-2 flex">
              <button
                onClick={() => setIsOpen(!isOpen)}
                type="button"
                className="bg-gray-200 inline-flex items-center justify-center p-2 rounded-md text-gray-400 hover:text-white hover:bg-gray-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-gray-800 focus:ring-white"
                aria-controls="mobile-menu"
                aria-expanded="false"
              >
                <span className="sr-only">Open main menu</span>
                {!isOpen ? (
                  <svg
                    className="block h-6 w-6"
                    xmlns="http://www.w3.org/2000/svg"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                    aria-hidden="true"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth="2"
                      d="M4 6h16M4 12h16M4 18h16"
                    />
                  </svg>
                ) : (
                  <svg
                    className="block h-6 w-6"
                    xmlns="http://www.w3.org/2000/svg"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                    aria-hidden="true"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth="2"
                      d="M6 18L18 6M6 6l12 12"
                    />
                  </svg>
                )}
              </button>
            </div>
          </div>
        </div>

        <Transition
          show={isOpen}
          enter="transition ease-out duration-100 transform"
          enterFrom="opacity-0 scale-95"
          enterTo="opacity-100 scale-100"
          leave="transition ease-in duration-75 transform"
          leaveFrom="opacity-100 scale-100"
          leaveTo="opacity-0 scale-95"
        >
          {() => (
            <div className="md:hidden float-right" id="mobile-menu">
              <div className="px-2 pt-2 pb-3 space-y-3 sm:px-3 w-screen bg-white">
                <NavBarOptions />
              </div>
              <a href="#" onClick={signOut}>
              <div className="flex border-t items-center bg-white shadow-lg pb-3 pt-3 pl-2">
                <ArrowLeftOnRectangleIcon className="h-9 w-9" />
                <div className="pl-5 inline-block">Sign Out</div>
              </div>
              </a>
            </div>
          )}
        </Transition>
      </nav>
    </>
  );
}
