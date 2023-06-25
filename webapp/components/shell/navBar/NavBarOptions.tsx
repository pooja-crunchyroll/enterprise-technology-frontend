import React from "react";
import Link from "next/link";
import { useRouter } from "next/router";
import { ChartBarSquareIcon, BriefcaseIcon} from '@heroicons/react/24/outline'
import Tooltip from "@mui/material/Tooltip";

type Props = {
  /** Whether the navbar options are appearing on a small screen, or a collapsed navbar */
  smallScreen?: boolean;
  expanded?: boolean;
};

export default function NavBarOptions({
  expanded = true, smallScreen
}: Props) {
  return (
    <>
      <NavItem
        link="/"
        svgIcon={<ChartBarSquareIcon className="w-8 h-8 inline text-white" />}
        title="Dashboard"
        expanded={expanded}
        smallScreen={smallScreen}
      />
        <NavItem
        link="/jobs"
        svgIcon={<BriefcaseIcon className="w-8 h-8 inline text-white" />}
        title="Jobs"
        expanded={expanded}
      />
    </>
  );
}

type NavItemProps = {
  link: string;
  svgIcon: JSX.Element;
  title: string;
  expanded?: boolean;
  smallScreen?: boolean;
};

const NavItem = ({ link, svgIcon, title, smallScreen, expanded = true }: NavItemProps) => {
  const router = useRouter();
  return (
    <Link href={link}>
      <a aria-label={title}
        className={`flex items-center bg-crunchy-orange no-underline hover:opacity-100 text-gray-800 rounded-md h-8 w-8 ${
          isActivePage(link, router.pathname) ? "opacity-100" : "opacity-70"
        }`}
      >
        <Tooltip title={title}>
        <span>
        {svgIcon}
        </span>
        </Tooltip>
        {expanded && <div className={smallScreen?"": "text-gray-600 pl-3"}>{title}</div>}
      </a>
    </Link>
  );
};

const isActivePage = (link: string, pathName: string) => {
  return pathName.toLowerCase() === link.toLowerCase();
};
