import React, { createContext, useContext, useState } from "react";
import NavBarOptions from "../navBar/NavBarOptions";
import Link from "next/link";
import { signOut } from "../../../utils/genericUtils";
import { ChatBubbleBottomCenterTextIcon, ArrowLeftOnRectangleIcon, ArrowLongLeftIcon, ArrowLongRightIcon } from '@heroicons/react/24/solid'
import Switch from "@mui/material/Switch";
import { Tooltip } from "@mui/material";

const CollapsedContext = createContext(false);

export default function SideNav() {
  const [expanded, setExpanded] = useState(false);

  return (
    <CollapsedContext.Provider value={expanded}>
      <div className={expanded? "flex flex-col text-green-50 px-4 py-4 items-center border-r border-gray-300": "flex flex-col text-green-50 px-4 py-4 border-r boder-gray-300 "}>
        <SideNavHeader />
        <SideNavMenu />
        <SideNavFooter collapsed={expanded} setExpanded={setExpanded} />
      </div>
    </CollapsedContext.Provider>
  );
}

const SideNavHeader = () => {
  const collapsed = useContext(CollapsedContext);

  return (
    <div className="flex items-center ml-2 pb-8 text-crunchy-orange hover:text-crunchy-light">
    <div></div>
      <Link href="/">
        <a className="text-xl font-bold no-underline flex-0 ">
        <ChatBubbleBottomCenterTextIcon className="h-6 w-6 inline"/>
          {!collapsed && <div className="inline ml-2">Narrator</div>}
        </a>
      </Link>
    </div>
  );
};

const SideNavMenu = () => {
  const collapsed = useContext(CollapsedContext);

  return (
    <nav className="space-y-4">
      <NavBarOptions smallScreen={false} expanded={!collapsed} />
    </nav>
  );
};

type sideNavFooterProps = {
  setExpanded: (expanded: boolean) => void;
  collapsed: boolean;
};

const SideNavFooter = ({collapsed, setExpanded }: sideNavFooterProps) => {
  return (
    <div className="absolute bottom-0 flex flex-col">
      <a
        href=""
        aria-label="Sign Out"
        className="flex pt-2 self-center items-center mt-7 no-underline text-gray-700 opacity-70 hover:opacity-100"
        onClick={signOut}
      >
        <Tooltip title="Sign Out">
          <span className="flex items-center">
        <ArrowLeftOnRectangleIcon className="h-9 w-9" />
        {!collapsed && <div className="pl-5 inline-block">Sign Out</div>}
        </span>
        </Tooltip>
      </a>
      <div className="flex pt-2">
        <div className="text-right flex-1 align-middle text-white mt-2" aria-label="Extend or Collapse Side Menu">
       <Tooltip title={collapsed? "Expand Side Menu": "Collapse Side Menu"}>
        <Switch color="warning"  checked={!collapsed} onChange={()=>{
          setExpanded(!collapsed);
        }} />
        </Tooltip>
        </div>
      </div>
    </div>
  );
};
