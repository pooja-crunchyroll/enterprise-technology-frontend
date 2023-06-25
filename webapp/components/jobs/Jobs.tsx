import React from "react";
import Shell from "../shell";
import Content from "../content/Content";
import Button from "@mui/material/Button";
import ActiveJobs from "./ActiveJobs";
import { Typography } from "@mui/material";

export default function Jobs() {
  return (
    <>
      <Shell>
        <Content title="Jobs">
          <div>
            <div className="flex flex-row items-end flex-1 pb-5">
              <div className="flex-1">
              </div>
              <Button variant="contained" className="text-white bg-crunchy-orange">Create Job</Button>

            </div>
            <Typography variant="h5" className="pb-3 text-gray-500">Active Jobs</Typography>
            <ActiveJobs />
            <Typography variant="h5" className="pb-3 text-gray-500 mt-11">Historical Jobs</Typography>
            <ActiveJobs />
          </div>
        </Content>
      </Shell>
    </>
  );
}
