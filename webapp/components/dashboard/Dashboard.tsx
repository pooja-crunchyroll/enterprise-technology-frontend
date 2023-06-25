import React from "react";
import Shell from "../shell";
import Content from "../content/Content";
import Paper from "@mui/material/Paper";
import { LinkIcon } from "@heroicons/react/24/outline";
import Link from "next/link";

export default function Dashboard() {
  return (
    <>
      <Shell>
        <Content title="Dashboard">
          <div className="flex flex-row items-center">
            <Link href="/jobs">
              <a aria-label="Active Transcriptions" className="text-gray-500 hover:text-gray-800">
            <Paper variant="outlined" className="p-2 flex flex-col items-center">
              <LinkIcon className="self-end h-6 w-6 "/>
                <h3 className="text-4xl">03</h3>
                Transcriptions
            </Paper>
            </a>
            </Link>
            
          </div>

        </Content>
      </Shell>
    </>
  );
}
