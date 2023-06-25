import { BellIcon } from "@heroicons/react/24/outline";
import Badge from "@mui/material/Badge";
import Link from "next/link";
import React from "react";

type Props = {
  title: string;
  children: JSX.Element;
};

export default function Content({ title, children }: Props) {
  return (
    <div className="flex flex-col">
      <div className="flex flex-row border-b-2 border-gray-200 pt-6 pb-2">
      <div className="text-xl  text-gray-600 px-6">
        {title}
      </div>
      <div className="flex-1"></div>
      <div className="mx-10">
      <Link href="/notifications">
      <a>
      <Badge color="warning" badgeContent={3}>
      <BellIcon className="w-8 h-8 inline text-gray-600" />
      </Badge>
      </a>
      </Link>
      </div>
      </div>
      <div className="flex-1 my-6 mx-6 rounded-xl">{children}</div>
    </div>
  );
}
